terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = var.aws_profile
}

# Get current caller identity for reference
data "aws_caller_identity" "current" {}

# Output AWS account information (will show during plan)
output "aws_execution_env" {
  value = <<EOT
╔════════════════════════════════════════════════════════════════════════════════
║ AWS Account Context
╠════════════════════════════════════════════════════════════════════════════════
║ Account ID:  ${data.aws_caller_identity.current.account_id}
║ Caller ARN:  ${data.aws_caller_identity.current.arn}
║ Caller User: ${data.aws_caller_identity.current.user_id}
║ AWS Region:  ${var.aws_region}
║ AWS Profile: ${var.aws_profile}
╚════════════════════════════════════════════════════════════════════════════════
EOT
}

# Output detailed caller identity
output "caller_identity" {
  value = {
    account_id = data.aws_caller_identity.current.account_id
    user_arn   = data.aws_caller_identity.current.arn
    user_id    = data.aws_caller_identity.current.user_id
  }
  description = "Details about the AWS identity used to run Terraform"
  sensitive = false
}

