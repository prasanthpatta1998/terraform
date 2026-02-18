variable "ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "tfinstance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "tfinstance" {
  description = "The name of the EC2 instance"
  type        = string
}
variable "tfbucket" {
  description = "The name of the S3 bucket"
  type        = string
}
