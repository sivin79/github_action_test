terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}


terraform {

  backend "s3" {
    bucket = "test-bucket-for-lessons"                // Bucket where to SAVE Terraform State
    key    = "lesson-CI-CD/tfstate/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "eu-west-1"                              // Region where bycket created
  }
}


# Create VPC
resource "aws_vpc" "test-vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "test-vpc+"
  }

}



# Create security group
resource "aws_security_group" "allow_ports_22_80" {
  name        = "allow_ssh"
  description = "Allow 22 port inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress = [{
    description      = "Allow 22 port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    self             = false
    prefix_list_ids  = []
    security_groups  = []
    ipv6_cidr_blocks = []
    },
    {
      description      = "allow 80 port"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
  }]


  egress = [{
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = false
    prefix_list_ids  = []
    security_groups  = []
  }]

  tags = {
    Name = "Test SG CI-CD+"
  }

}
