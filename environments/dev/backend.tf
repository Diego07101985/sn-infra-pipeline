terraform {
  backend "s3" {
    bucket         = "sn-ml-pipeline-terraform-state-files"
    key            = "prod/terraform.tfstate"
    dynamodb_table = "dev-sn-ml-pipeline-terraform-running-state-locks"
    region         = "us-east-1"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
