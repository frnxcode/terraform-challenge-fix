# Terraform Technical Test

## Prerequisites

1. Terraform CLI (>= 1.9.0)
2. Git CLI
3. (Optional, for local checks) `tflint` and `tfsec`/`trivy`

## Instructions

This repository contains a Terraform configuration for a simple web
application. The configuration is **incomplete and contains errors**.

Work on a branch and open a Pull Request that:

1. Ensures the GitHub CI pipeline executes successfully on PRs and merges
2. Fixes any configuration errors identified by the CI pipeline
3. DRYs (Don't Repeat Yourself) the code for **subnet creation** and
   **route table association**

## What will be validated

1. Git experience (amend a commit message, squash and rebase)
2. CI pipeline configuration
3. Terraform linting (variables, formatting)
4. Terraform security misconfiguration
5. Use of `count` vs `for_each`

## Layout

```
.
├── .github/workflows/terraform.yml
├── versions.tf
├── main.tf
├── variables.tf
├── vpc.tf
├── web.tf
├── storage.tf
└── outputs.tf
```

Good luck.

---

## Solution

This repository was fixed and hardened as a practical DevOps exercise. The following changes were made on branch `fix/terraform-misconfigurations` via Pull Request #1.

### What Was Fixed

- **Bug:** Variable name typo `var.public_subnet_cidr` corrected to `var.public_subnet_cidrs`
- **Bug:** Invalid `depends_on = [var.vpc_cidr]` removed — variables are not valid depends_on targets
- **Security:** SSH ingress restricted from `0.0.0.0/0` to `var.allowed_cidr`
- **Security:** EBS root volume encryption enabled
- **Security:** IMDSv2 enforced via `metadata_options { http_tokens = "required" }`
- **Security:** S3 public access block, versioning, and KMS encryption added
- **Security:** VPC Flow Logs added with CloudWatch log group and scoped IAM role
- **Variables:** Removed unused `db_password` (contained hardcoded plaintext secret) and `enable_logging`
- **DRY:** Route table associations converted from `count` to `for_each` for stable resource keys
- **CI:** GitHub Actions pipeline created running fmt, validate, tflint, and trivy on every PR
- **Hooks:** pre-commit hooks added for local enforcement before every commit

### CI Pipeline

Every pull request and merge to main automatically runs:

1. `terraform fmt -check` — formatting validation
2. `terraform validate` — configuration syntax check
3. `tflint` — linting and unused variable detection
4. `trivy config .` — security misconfiguration scanning (CRITICAL and HIGH blocking)

### Issues Fixed

| Severity | Count |
|---|---|
| Critical | 3 |
| High | 9 |
| Medium | 3 |
| Low | 3 |
| Warning | 3 |
| **Total** | **23** |

### Prerequisites

```bash
terraform >= 1.9.0
tflint
trivy
pre-commit
```

### Setup

```bash
git clone https://github.com/frnxcode/terraform-challenge-fix.git
cd terraform-challenge-fix
pre-commit install
terraform init
```
