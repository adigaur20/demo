######## This file is for provider aws
provider "aws" {
  #version = "~> 1.24.0"
  version = "~> 2.5.0"
# Lotadi
  region     = "${var.region}"
  assume_role {
    role_arn     = "arn:aws:iam::<account_number>:role/Terraform"
  }
}
terraform {
  backend "s3" {
    bucket = "demo-tf-state"
    dynamodb_table = "demo-tf-state"
    key    = "demo/tfstate"
    region = "eu-central-1"
    role_arn     = "arn:aws:iam::<account_number>:role/Terraform"
  }
}
