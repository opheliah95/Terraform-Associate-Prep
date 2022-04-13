terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# configure provider to be aws
provider "aws" {
  region = var.aws_region
}

# setup vpc
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
  }
}

# setup private subnets
resource "aws_subnet" "private_subnet"{
  for_each = var.private_subnet
  vpc_id = aws_vpc.my-vpc
  cidr_block = cidrsubnet(var.vpc_cidr, each.value)
}

