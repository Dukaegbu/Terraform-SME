output "vpc_id" {
  value = aws_vpc.myapp-vpc.id
}

output "aws_security_group" {
  value = aws_security_group.myapp-sg.id
}

output "ec2_public_ip" {
  value = module.myapp-webserver.instance.public_ip
}