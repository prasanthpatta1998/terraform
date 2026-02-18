provider "aws" {
  
}

resource "aws_s3_bucket" "tf-bucket" {
    bucket = "prasa-bucket1-tf-feb-02-2026" 
    tags = {
      Name = "tf-bucket"
    }

    lifecycle {
      ignore_changes = [ tags ]
      prevent_destroy = true
      create_before_destroy = true
    }
}
