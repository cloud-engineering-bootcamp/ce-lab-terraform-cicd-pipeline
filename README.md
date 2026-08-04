# Lab M5.02 - Terraform CI/CD Pipeline
 
## Architecture
 
\`\`\`
Pull Request ──► CI Workflow ──► fmt + validate + plan ──► PR Comment
                                                              │
Merge to main ──► CD Workflow ──► init + plan + apply ────► AWS
                      │
              [production environment]
              [required reviewer approval]
\`\`\`
 
## Infrastructure
- **VPC:** 10.1.0.0/16 with DNS support
- **Public Subnets:** 2 (across 2 AZs)
- **Private Subnets:** 2 (across 2 AZs)
- **Internet Gateway** with public route table
- **State Backend:** S3 + DynamoDB locking
 
## Workflows
| Workflow | Trigger | Steps |
|----------|---------|-------|
| CI (`ci.yml`) | Pull request to main | fmt, validate, plan, PR comment |
| CD (`cd.yml`) | Push to main | init, plan, apply |
 
## Secrets Required
| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | IAM access key |
| `AWS_SECRET_ACCESS_KEY` | IAM secret key |