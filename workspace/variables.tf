variable "aws_region" {
  type        = string
  description = "region to be specified"
}

variable "instance_type" {
  type        = string
  description = "type of ec2 instance"
}

variable "vpc_name" {
  type    = string
  default = "demo_vpc"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }
}
variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
}

# cidr new bits, new bits + netnum is final network mask
variable "cidr_newbits" {
  default = 8
  description = "newbits for cidr"
  type = number
}

variable "cidr_netnum" {
  default = 1
  description = "netnum for cidr, no more than new bits"
  type = number
}
