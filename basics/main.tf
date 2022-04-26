provider "aws" {

}

# aws vpc subnet
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "myvpc"
    Environment = "demo_environment"
    Terraform   = "true"
  }
}

# a subnet for the vpc
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

# a internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# aws security group
resource "aws_security_group" "my_security_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "connection from http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "inbound connection from port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
    Instance_Name="Terraform_EC2_Instance"
  }
}

# aws data using a ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# create aws routing table
resource "aws_route_table" "my_routing_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.0.0/12"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "my_routing_table"
  }
}

# associate route table to aws subet
# so this is a public subnet
resource "aws_route_table_association" "association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.my_routing_table.id
}

# aws ec2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.my_security_group.id]
  key_name = "test"
  tags = {
    Name = "HelloWorld"
  }
}