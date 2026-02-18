provider "aws" {
  
}

locals {
    ingress_rules = [
        {
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        },
        {
            from_port = 443
            to_port = 443
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        },
         {
            from_port = 3306
            to_port = 3306
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"] 
         }
    ]
}

resource "aws_vpc" "tf-vpc" {
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "tf-vpc"
    }
}

resource "aws_security_group" "tf-sg" {
  vpc_id = aws_vpc.tf-vpc.id
  name = "tf-sg"

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}