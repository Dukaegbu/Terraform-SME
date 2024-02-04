provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block[0].subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.subnet_cidr_block[0].Name}-net"
  }
}

output "vpc_id" {
  value = aws_vpc.myapp-vpc.id
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  # route{
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.myapp-igw.id
  # }
  route = [ {
    carrier_gateway_id = "value"
    cidr_block = "0.0.0.0/0"
    core_network_arn = "value"
    destination_prefix_list_id = "::/0"
    egress_only_gateway_id = "value"
    ipv6_cidr_block = "::/0"
    gateway_id = "${aws_internet_gateway.myapp-igw.id}"
    local_gateway_id = "value"
    nat_gateway_id = "value"
    network_interface_id = "value"
    transit_gateway_id = "value"
    vpc_endpoint_id = "value"
    vpc_peering_connection_id = "value"
  } ]
  tags = {
    Name = "${var.env_prefix}-igw"
  }
  
}

