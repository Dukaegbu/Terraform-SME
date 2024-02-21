variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

variable "environment" {
  description = "deployment environment"
}

variable "avail_zone" {
  description = "availability zone"
}

variable "my_ip" {
  description = "my ip address"
}

variable "instance_type" {
}

variable "my_public_key" {
  description = "my public key location path"
}

variable "subnet_cidr_block" {
    description = "vpc cidr block"
}

variable "env_prefix" {
  description = "environment prefix"
}
variable "ami-image" {
}