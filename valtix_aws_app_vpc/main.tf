######################################
# AMI & Availability Zone Data Sources
######################################
data "aws_availability_zones" "available" {}

resource "aws_key_pair" "it" {
  key_name   = var.key_name
  public_key = file(format("${dirname(path.cwd)}/%s", var.pub_key_file_path))
  count      = var.create_key == "true" ? 1 : 0
}

####################################
# VPC / Subnets / Route Tables / IGW
####################################
resource "aws_vpc" "it" {
  cidr_block = var.vpc_cidr

  tags = {
    Name   = "${var.prefix}_vpc"
    prefix = var.prefix
  }
}

resource "aws_default_route_table" "it" {
  default_route_table_id = aws_vpc.it.default_route_table_id

  tags = {
    Name   = "${var.prefix}_vpc"
    prefix = var.prefix
  }
}

# create internet gw and attach it to the vpc
resource "aws_internet_gateway" "it" {
  vpc_id = aws_vpc.it.id

  tags = {
    Name   = "${var.prefix}_vpc"
    prefix = var.prefix
  }
}

# Two subnets per AZ, called pub, priv.
# subnets are created in each of the zones

resource "aws_subnet" "it_priv" {
  vpc_id            = aws_vpc.it.id
  count             = var.zones
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_bits, (count.index * 3))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name   = "${var.prefix}_vpc_z${count.index + 1}_priv"
    prefix = var.prefix
  }
}

resource "aws_subnet" "it_pub" {
  vpc_id            = aws_vpc.it.id
  count             = var.zones
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_bits, (count.index * 3) + 1)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name   = "${var.prefix}_vpc_z${count.index + 1}_pub"
    prefix = var.prefix
  }
}

resource "aws_route_table" "it_priv" {
  vpc_id = aws_vpc.it.id
  count  = var.zones

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.it.id
  }

  tags = {
    Name   = "${var.prefix}_vpc_z${count.index + 1}_priv"
    prefix = var.prefix
  }
}

# associate priv route table with priv subnet
resource "aws_route_table_association" "it_priv" {
  count          = var.zones
  subnet_id      = aws_subnet.it_priv[count.index].id
  route_table_id = aws_route_table.it_priv[count.index].id
}

resource "aws_route_table" "it_pub" {
  vpc_id = aws_vpc.it.id
  count  = var.zones

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.it.id
  }

  tags = {
    Name   = "${var.prefix}_vpc_z${count.index + 1}_pub"
    prefix = var.prefix
  }
}

# associate pub route table with pub subnet
resource "aws_route_table_association" "it_pub" {
  count          = var.zones
  subnet_id      = aws_subnet.it_pub[count.index].id
  route_table_id = aws_route_table.it_pub[count.index].id
}


# jumpbox security group to allow ssh to jumpbox and all egress traffic
resource "aws_security_group" "it_pub" {
  name   = "${var.prefix}_vpc_pub_sg"
  vpc_id = aws_vpc.it.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name   = "jumpbox"
    prefix = var.prefix
  }
}

# priv sg is used by the instances running the customer apps.
# by default this is setup to open ports 80 and 443. customer must add
# ports when the new apps are launched on other ports. since the
# customer apps are expected to be in a private subnet, there is no
# reachability to the subnet from outside the vpc. Outbound rules are
# opened wide for intra-vpc communications. Customer can change/restrict
# as required.
resource "aws_security_group" "it_priv" {
  name   = "${var.prefix}_vpc_priv_sg"
  vpc_id = aws_vpc.it.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name   = "${var.prefix}_vpc_priv_sg"
    prefix = var.prefix
  }
}

###############
# EC2 Instances
###############

# create 1 backend host in each zone
resource "aws_instance" "it_priv" {
  ami                         = var.ami_id
  associate_public_ip_address = true

  count                       = var.zones
  key_name                    = var.key_name
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.it_priv.id]
  subnet_id                   = aws_subnet.it_priv[count.index].id
  availability_zone           = data.aws_availability_zones.available.names[count.index]

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name   = "${var.prefix}_vpc_priv-${count.index + 1}"
    prefix = var.prefix
    role = "prod"
  }
  volume_tags = {
    Name   = "${var.prefix}_vpc_priv-${count.index + 1}"
    prefix = var.prefix
  }

  user_data = <<EOF
#!/bin/bash
docker pull ubuntu:16.04
docker pull eddievaltix/sedemo-web
EOF

}

# one instance for jumpbox
resource "aws_instance" "it_pub" {
  ami                         = var.ami_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.it_pub.id]
  subnet_id                   = aws_subnet.it_pub[0].id

  provisioner "file" {
    source        = format("${path.cwd}/%s", var.prv_key_file_path)
    destination   = "/home/centos/.ssh/id_rsa"
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file(format("${path.cwd}/%s", var.prv_key_file_path))
      host        = aws_instance.it_pub.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = ["chmod 400 /home/centos/.ssh/id_rsa"]
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file(format("${path.cwd}/%s", var.prv_key_file_path))
      host        = aws_instance.it_pub.public_ip
    }
  }

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name   = "${var.prefix}_vpc_jump"
    prefix = var.prefix
  }
  volume_tags = {
    Name   = "${var.prefix}_vpc_jump"
    prefix = var.prefix
  }
}
