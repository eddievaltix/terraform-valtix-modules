locals {
  egress_cidr = "0.0.0.0/0"
}

provider "aws" {
  alias = "protected"
}

###############################################
# Transit Gateway and Protected VPC Data Source
###############################################

data "aws_ec2_transit_gateway" "this" {
  id = var.transit_gateway_id
}

data "aws_vpc" "this" {
  provider = aws.protected
  tags = {
    Name = var.protected_vpc_name
  }
}

#get the subnet IDs that are tagged for use with the vpc attachment
data "aws_subnet_ids" "this" {
  provider = aws.protected
  vpc_id   = data.aws_vpc.this.id
  tags = {
    valtix_tgw = "true"
  }
}

data "aws_vpc" "gw" {
  tags = {
    Name = var.valtix_gateway_vpc_name
  }
}

##########################################
# VPC Attachments, route table association
##########################################

#create the protected VPC attachment to transit gateway in the protected VPC account
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  provider           = aws.protected
  subnet_ids         = data.aws_subnet_ids.this.ids
  transit_gateway_id = data.aws_ec2_transit_gateway.this.id
  vpc_id             = data.aws_vpc.this.id
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"
  tags = {
    Name = "valtix-${var.valtix_cloud_account_name}-${var.protected_vpc_name}"
  }
}

#create the route table for the protected VPC attachment
resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = data.aws_ec2_transit_gateway.this.id
  tags = {
    Name = "valtix-${var.valtix_cloud_account_name}-${var.protected_vpc_name}"
  }
}

#find gateway vpc attachment resource so we can add it to the protected vpc attachment route table
data "aws_ec2_transit_gateway_vpc_attachment" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.gw.id]
  }
}

#create the transit gateway route for the protected vpc attachment route table
resource "aws_ec2_transit_gateway_route" "this" {
  #destination_cidr_block         = data.aws_vpc.gw.cidr_block
  destination_cidr_block         = var.is_egress == "true" ? local.egress_cidr : data.aws_vpc.gw.cidr_block
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

#associate the protected vpc attachment transit gateway route table to the protected vpc attachment
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}