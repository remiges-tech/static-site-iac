terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"

      # The root module must pass an aliased us-east-1 provider.
      # CloudFront can only use ACM certificates from us-east-1.
      configuration_aliases = [aws.us-east-1]
    }
  }
}
