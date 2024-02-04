provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.environment
  }
}

resource "aws_subnet" "dev-subne1-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block[0].subnet_cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name = var.subnet_cidr_block[0].Name
  }
}

output "vpc_id" {
  value = aws_vpc.development-vpc.id
}


# data "aws_vpc" "existing_vpc" {
#   default = false
# }

# resource "aws_subnet" "dev-subne1-2" {
#   vpc_id = "vpc-080800ee40cefb0fd" 
#   cidr_block = "172.30.3.0/24"
#   availability_zone = "us-east-1a"
# }