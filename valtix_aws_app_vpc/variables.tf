variable "prefix" {
    description = "prefix for allb resources created in this VPC"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
}

variable "subnet_bits" {
  description = "Number of additional bits (on top of the vpc cidr mask) to use in the subnets inside VPC (final subnet would be the mask of vpc cidr + the value provided for this variable)"
  default = 8
}

variable "zones" {
  description = "the number of availability zones that will be used.  Will determine the number of instances to deploy (in each AZ)"
  default = 2
}

variable "key_name" {
  description = "SSH Keypair name"
}

variable "create_key" {
  description = "Boolean to determine whether to create the SSH key"
  default = "false"
}

variable "pub_key_file_path" {
  description = "relative path to the public key file for key pair creation"
}

variable "prv_key_file_path" {
  description = "relative path to the private key file to add to id_rsa in instances"
}

variable "instance_type" {
  description = "type of demo instances to deploy"
}
