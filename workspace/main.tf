terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

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
resource "aws_subnet" "private_subnets" {
  for_each   = var.private_subnets
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, var.cidr_newbits, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name = each.key
    Terraform = "true"
  }
}

