terraform {
  backend "s3" {
    bucket         = "ce-bootcamp-tfstate-adnannooruddin"
    key            = "m5-02-cicd/terraform.tfstate"
    region         = "eu-north-1"
 
    use_lockfile = true
    encrypt      = true
  }
}