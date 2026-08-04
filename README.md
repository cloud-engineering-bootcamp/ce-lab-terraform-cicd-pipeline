# Lab M5.02 - Terraform CI/CD Pipeline

**Cloud Engineering Bootcamp - Week 5**
**Module:** Cloud Automation & CI/CD

## Architecture

```
Pull Request ──► CI Workflow ──► fmt + validate + plan ──► PR Comment
                                                              │
Merge to main ──► CD Workflow ──► init + plan + apply ────► AWS
                                                              │
                                                   [production environment]
                                                   [required reviewer approval]
```

CI validates every pull request before it can be merged. CD deploys only after
the change has landed on `main`, gated behind a GitHub Environment.

## Repository Structure

```
ce-lab-terraform-cicd-pipeline/
├── .github/
│   └── workflows/
│       ├── ci.yml           # PR: fmt, validate, plan, comment
│       └── cd.yml           # main: init, plan, apply
├── backend.tf               # S3 remote state
├── main.tf                  # VPC, subnets, IGW, route table
├── variables.tf             # Input variables
├── outputs.tf               # VPC and subnet identifiers
├── terraform.tfvars         # Variable values
├── .gitignore
└── README.md
```

## Infrastructure

- **VPC:** `10.1.0.0/16` with DNS support and DNS hostnames enabled
- **Public Subnets:** 2 (`10.1.1.0/24`, `10.1.2.0/24`) across 2 AZs, auto-assign public IP
- **Private Subnets:** 2 (`10.1.11.0/24`, `10.1.12.0/24`) across 2 AZs
- **Internet Gateway** with a public route table (`0.0.0.0/0` → IGW)
- **Route Table Associations** for both public subnets

## Workflows

| Workflow | Trigger | Steps |
|----------|---------|-------|
| CI (`ci.yml`) | Pull request to `main` | fmt check, init, validate, plan, post plan as PR comment |
| CD (`cd.yml`) | Push to `main` | init, plan, apply `-auto-approve` |

### Why they are separate

CI runs on the proposed change and only reads state — reviewers see the exact
plan in the PR before approving. CD runs once the change is on `main`, so
`-auto-approve` is safe: the diff was already reviewed.

## Remote State

```hcl
backend "s3" {
  bucket       = "ce-bootcamp-tfstate-dennisb"
  key          = "m5-02-cicd/terraform.tfstate"
  region       = "us-east-1"
  use_lockfile = true
  encrypt      = true
}
```

State is versioned in S3 and encrypted at rest. Locking prevents two pipeline
runs from mutating state concurrently. A `terraform-locks` DynamoDB table is
also provisioned for the classic locking mechanism.

## GitHub Environment

The CD job declares `environment: production`, binding it to a GitHub
Environment configured with:

- **Required reviewers** — a deploy waits for manual approval
- **Wait timer** — 5 minutes before the job starts

This produces an audit trail of who approved each deployment.

## Secrets Required

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | IAM access key |
| `AWS_SECRET_ACCESS_KEY` | IAM secret key |

Configured under **Settings → Secrets and variables → Actions**.

## How to Use

```bash
git clone https://github.com/Draian123/ce-lab-terraform-cicd-pipeline.git
cd ce-lab-terraform-cicd-pipeline

terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

## Key Takeaways

- Separate CI and CD workflows give a clear split: validate before merge, deploy after
- PR comments with plan output let reviewers see exactly what will change in AWS
- GitHub Environments create an audit trail and allow deployment gates
- Remote state with locking prevents concurrent modifications
- `-auto-approve` is safe in CD because the change was already reviewed in the PR
