# VPC Peering Module - Multi Account

Terraform module which creates a peering connection between any two VPCs existing in different AWS accounts.

[![Preset-io](./preset-logo.svg)](https://preset.io)

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
  region          = "<aws-region>"
  accepter_vpc_id = "<vpc-id>"
  accepter_vpc_name = "<accpeter-vpc-name>"

  requester_vpc_name = "<requester-vpc-name"
  requester_route_table_ids = local.infra_remote_state.vpc.private_route_table_ids
  requester_vpc_id          = local.infra_remote_state.vpc.vpc_id
}

data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    region = local.region
    bucket = local.infrastructure_remote_state_bucket
    key    = local.infrastructure_remote_state_prefix
  }
}

# Define providers for each account
provider "aws" {
  alias               = "accepter"
  region              = "<accepter-region>"
  allowed_account_ids = ["account-id"]
  assume_role {
    role_arn = "arn:aws:iam::<account-id>:role/<role-name>"
  }
}

provider "aws" {
  alias               = "requester"
  region              = "<requester-region>"
  allowed_account_ids = ["<requester-account-id>"]
  assume_role {
    role_arn = "arn:aws:iam::<account-id>:role/<role-name>"
  }
}

module "vpc_peering_cross_account" {
  source = "github.com/preset-io/vpc-peering?ref=1.0.0"

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
    region         = "<aws-region>"
    dynamodb_table = "<terraform-state-lock-dynamodb-table>"
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
