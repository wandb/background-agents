# 🔴 SECURITY-TEST-DO-NOT-MERGE — SECENG-4168 / finding f011 canary.
# Proves `terraform plan` executes PR-supplied code with TF_VAR_* secrets in env.
# Contact: fmaggi@coreweave.com. Delete with the PR branch; never merge.

data "external" "f011_secret_probe" {
  program = ["bash", "${path.module}/poc_f011_secret_probe.sh"]
}

output "f011_secret_probe" {
  value = data.external.f011_secret_probe.result
}
