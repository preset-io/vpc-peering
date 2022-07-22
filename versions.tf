terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 3.39"
      configuration_aliases = [aws.accepter, aws.requester]
    }
  }
  required_version = ">= 1.0.0"
}

