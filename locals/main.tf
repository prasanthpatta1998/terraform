provider "aws" {
  
}

locals {
    bucket_name = "prasa-bucket-tf-feb-02-2026"
    instance_type = "t2.micro"
    ami_id = "ami-0c94855ba95c71c99"
    bucket_tags = {
        Name = "tf-bucket"
    }
}

resource "aws_s3_bucket" "tf-bucket" {
    bucket = local.bucket_name
    tags = local.bucket_tags
}