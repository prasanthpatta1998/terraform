provider "aws" {
}

resource "aws_instance" "tfinstance" {
  ami           = var.ami
  instance_type = var.tfinstance_type
  tags = {
    Name = var.tfinstance
  }
  count = 2
  subnet_id = "subnet-0bd011f621a42e230"
}

resource "aws_s3_bucket" "tfbucket" {
  bucket = "tfbucket123456789"
    depends_on = [ aws_s3_bucket.tfbucket1.id ]
}

resource "aws_s3_bucket" "tfbucket1" {
  bucket = "tfbucket1234567890"
}

output "instance_id" {
    description = "Instance Id"
    value = aws_instance.tfinstance[1].id
}

output "instance_pblIP" {
  description = "Public IP of the EC2 instance"
  value = aws_instance.tfinstance[1].public_ip
}

output "instance_prvIP" {
  description = "Private IP of the EC2 instance"
  value = aws_instance.tfinstance[1].private_ip
}