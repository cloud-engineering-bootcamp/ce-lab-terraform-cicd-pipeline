terraform {
  backend "s3" {
    bucket = "ce-bootcamp-tfstate-dennisb"
    key    = "m5-02-cicd/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
    encrypt      = true
  }
}
