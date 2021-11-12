######## This file is for provider aws
provider "aws" {
  version = "~> 3.65.0"
  region     = "${var.region}"
}

### Best prcatice is to use backend but can't use it here in demo
#terraform {
#  backend "s3" {
#    bucket = "demo-tf-state"
#    dynamodb_table = "demo-tf-state"
#    key    = "demo/tfstate"
#    region = "eu-central-1"
#    role_arn     = "arn:aws:iam::<account_number>:role/Terraform"
#  }
#}
