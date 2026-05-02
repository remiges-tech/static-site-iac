terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# CloudFront can only use ACM certificates from us-east-1.
provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = var.aws_profile
}
