provider "aws" {
  region  = var.aws_region     
  profile = var.aws_profile  
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}