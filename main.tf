provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id
}

module "myapp-webserver" {
  source = "./modules/webserver"
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  my_public_key = var.my_public_key
  instance_type = var.instance_type
  subnet_id = module.myapp-subnet.subnet.id
  my_ip = var.my_ip
  vpc_security_group_ids = aws_security_group.myapp-sg.id
  ami-image = var.ami-image
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
