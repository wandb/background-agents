#!/usr/bin/env bash
# 🔴 SECURITY-TEST-DO-NOT-MERGE — SECENG-4168 / f011 canary payload.
# Runs as a child of `terraform plan` (data.external). Emits, per TF_VAR_* env
# var: value length + 12-hex HMAC-SHA256 under a key generated and discarded
# here, so no secret material or offline-verifiable digest is output.
set -euo pipefail

cat > /dev/null # consume terraform's data.external query

key="$(head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n')"

hmac12() { printf '%s' "$1" | openssl dgst -sha256 -hmac "$key" -r | cut -c1-12; }

json="{"
sep=""
for name in $(compgen -e | grep '^TF_VAR_' | sort); do
  val="${!name-}"
  json+="${sep}\"${name}\":\"len=${#val},hmac12=$(hmac12 "$val")\""
  sep=","
done
json+="${sep}\"_meta\":\"SECENG-4168 f011 canary; repo=${GITHUB_REPOSITORY-?} run_id=${GITHUB_RUN_ID-?}; ephemeral key discarded\""
json+="}"
printf '%s' "$json"
