data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.ami-image]
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
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.vpc_security_group_ids]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  #used to execute commands in ec2
  user_data = file("entry-script.sh")

  #used for when you modify the user data field it will re provision the instance 
  user_data_replace_on_change = true

  #used to execute commands in ec2(not recommended)
  # provisioner "remote-exec" {
  #   script = "entry-script.sh"
  # }

   tags = {
    Name = "${var.env_prefix}-server"
  }
}