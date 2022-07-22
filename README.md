# VPC Peering Module - Multi Account

Terraform module which creates a peering connection between any two VPCs existing in different AWS accounts.

[![SWUbanner](./preset-logo.png)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

## Usage

This module supports performing this action from a 3rd account (e.g. a "root" account) by specifying the roles to assume for each member account.

**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

**IMPORTANT:** Do not pin to `master` because there may be breaking changes between releases. Instead, pin to the release tag  (e.g. `?ref=tags/x.y.z`) of one of our [[latest releases](https://github.com/preset-io/vpc-peering/releases)

(For MPC users, the requester is the account Preset was provisioned on)

```terraform

locals {
  accepter_vpc_id = "vpc-id"
  accepter_vpc_name = "accpeter name"

  requester_vpc_name = "requester account"
  
  # list of comma separated private route tables for requester VPC
  requester_route_table_ids = ["rtb-0722cac0edd61951a", "rtb-0d2d08dd1978703b3", "rtb-0ff8d0084bc9e61b3"]
  requester_vpc_id  = "vpc-id"
}

# Define providers for each account
provider "aws" {
  alias               = "accepter"
  region              = "us-west-2"
  allowed_account_ids = ["account-id"]
  assume_role {
    role_arn = "arn:aws:iam::<account-id>:role/<role-name>"
  }
}

provider "aws" {
  alias               = "requester"
  region              = "us-west-2"
  allowed_account_ids = ["account-id"]
  assume_role {
    role_arn = "arn:aws:iam::<account-id>:role/<role-name>"
  }
}

module "vpc_peering_cross_account" {
  source = "https://github.com/preset-io/vpc-peering?ref=1.0.0"
  
  providers = {
    aws.requester = aws.requester
    aws.accepter  = aws.accepter
  }

  requester_tags = {
    purpose = "peering connection"
  }

  requester_vpc_name        = local.requester_vpc_name
  requester_vpc_id          = local.requester_vpc_id
  requester_route_table_ids = local.requester_route_table_ids
  requester_route_table_cnt = length(local.requester_route_table_ids)

  accepter_vpc_name = local.accepter_vpc_name
  accepter_region   = "us-west-2"
  accepter_vpc_id   = local.accepter_vpc_id
  accepter_tags     = { 
    purpose = "peering connection" 
  }
}


terraform {
  # configure your backend here
  backend "s3" {
    bucket         = "<s3-bucket-name>>"
    key            = "/path/to/terraform/state"
    encrypt        = true
    acl            = "private"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock-dynamodb"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72.0" # Maximum version (~>)
    }
  }

  required_version = "~> 1.0.11"
}


```
