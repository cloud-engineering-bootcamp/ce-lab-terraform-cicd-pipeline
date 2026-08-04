# Lab M5.02 - Terraform CI/CD Pipeline

## Architecture

Pull Request → CI Workflow (fmt, validate, plan) → PR Comment
Merge to main → CD Workflow (init, apply) → production environment (required review) → AWS

## Infrastructure

- VPC (`10.1.0.0/16`) with DNS support enabled
- 2 public subnets across 2 availability zones
- Internet Gateway + public route table
- Remote state stored in S3 (`ce-lab-tfstate-lojt-cloud`), with native S3 locking enabled

## Workflows

|      Workflow              |    Trigger             |                  Steps                                                    |

| CI (`terraform-plan.yml`)  | Pull request to `main` | fmt check, init, validate, plan, post plan as PR comment                  |
| CD (`terraform-apply.yml`) | Push to `main`         | init, apply (`-auto-approve`), gated by `production` environment approval |

## Deployment Process

1. Make infrastructure changes on a feature branch
2. Open a PR — CI runs automatically and posts the `terraform plan` output as a comment for review
3. Once approved and merged, CD triggers on push to `main`
4. CD pauses at the `production` environment gate for manual approval
5. On approval, `terraform apply -auto-approve` runs and applies the change to AWS

## Secrets Required

|       Secret            | Description    |

| `AWS_ACCESS_KEY_ID`     | IAM access key |
| `AWS_SECRET_ACCESS_KEY` | IAM secret key |

## Local Development

\`\`\`bash
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan
\`\`\`