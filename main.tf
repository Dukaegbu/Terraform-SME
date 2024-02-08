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
  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  # route = [ {
  #   carrier_gateway_id = "value"
  #   cidr_block = "0.0.0.0/0"
  #   core_network_arn = "value"
  #   destination_prefix_list_id = "::/0"
  #   egress_only_gateway_id = "value"
  #   ipv6_cidr_block = "::/0"
  #   gateway_id = "${aws_internet_gateway.myapp-igw.id}"
  #   local_gateway_id = "value"
  #   nat_gateway_id = "value"
  #   network_interface_id = "value"
  #   transit_gateway_id = "value"
  #   vpc_endpoint_id = "value"
  #   vpc_peering_connection_id = "value"
  # } ]
  tags = {
    Name = "${var.env_prefix}-igw"
  }
  
}

resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress  {
    from_port = 22
    to_port = 22
    protocol ="TCP"
    cidr_blocks ="${var.my_ip}"
    
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol ="TCP"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
    prefix_list_ids =[]
  } 
   tags = {
    Name = "${var.env_prefix}-sg"
  }

}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.3.20240131.0-kernel-6.1-x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}

resource "aws_key_pair" "ssh-key" {
  public_key = file(var.my_public_key)
  key_name = "server-key"
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type[0]
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  #user to execute commands in ec2
  user_data = file("entry-script.sh")

  #used for when you modify the user data field it will re provision the instance 
  user_data_replace_on_change = true

   tags = {
    Name = "${var.env_prefix}-server"
  }
}

output "aws_ami" {
  value = data.aws_ami.latest-amazon-linux-image.id
}