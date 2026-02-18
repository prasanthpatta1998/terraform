provider "aws" {
}

terraform {
  backend "s3" {
    bucket = "prasa-bucket"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state"
  }
}

resource "aws_s3_bucket" "state_lock" {
  bucket = "my-terraform-state-lock-bucket"
}