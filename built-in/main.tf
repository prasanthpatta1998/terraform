provider "aws" {
  
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

locals {
  string1 = "Prasanth"
}

output "name" {
  value = upper(local.string1)
}

output "name1" {
  value = lower(local.string1)
}

output "name2" {
  value = length(local.string1)
}

output "name3" {
  value = substr(local.string1, 0, 3)
}

output "name4" {
  value = replace(local.string1, "P", "R")
}

output "name5" {
  value = trimspace(local.string1)
}

output "name6" {
  value = split(local.string1, "")
}

output "name7" {
  value = join(",", ["a","b","c"])
}

output "name8" {
  value = "Ended Strings"
}

output "name9" {
  value = max(1, 5, 9)
}

output "name10" {
  value = min(1, 5, 9)
}

output "name11" {
  value = abs(-10)
}

output "name12" {
  value = base64encode("Prasanth")
}

output "name13" {
  value = base64decode("UHJhc2FudGg=")
}

output "name14" {
  value = timestamp()
}   

output "name15" {
  value = slice([1, 2, 3, 4], 2, 4)
}

output "name16" {
  value = true ? "It is True" : "It is False"
}