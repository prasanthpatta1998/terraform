provider "aws" {
}

variable "s3names" {
    type = list(string)
    default = [ "prasa-bucket-tf-feb-02-20261", "prasa-bucket-tf-feb-02-20262", "prasa-bucket-tf-feb-02-20263" ]
}

variable "s3setnames" {
    type = set(string)
    default = [ "prasa-bucket-tf-feb-02-20261", "prasa-bucket-tf-feb-02-20262", "prasa-bucket-tf-feb-02-20263" ]
}

variable "s3tags" {
  type = list(string)
  default = [ "tag1", "tag2", "tag3" ]
}

variable "s3bucketNames" {
  type = map(string)
  default = {
    "prasa-bucket-tf-feb-02-20261" = "tag1",
    "prasa-bucket-tf-feb-02-20262" = "tag2",
    "prasa-bucket-tf-feb-02-20263" = "tag3"
  }
}

resource "aws_s3_bucket" "tf-list-bucket" {
    count = length(var.s3names)
    bucket = var.s3names[count.index]
    tags = {
        Name = var.s3tags[count.index]
    }
}

resource "aws_s3_bucket" "tf-set-bucket" {
    for_each = var.s3setnames
    bucket = each.value
}

resource "aws_s3_bucket" "tf-bucket" {
    for_each = var.s3bucketNames
    bucket = each.key
    tags = {
        Name = each.value
    }
}