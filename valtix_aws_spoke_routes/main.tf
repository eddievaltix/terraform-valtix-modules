locals {
  egress_cidr = "0.0.0.0/0"
}

provider "aws" {
  alias = "protected"
}

###############################################
# Transit Gateway and Protected VPC Data Source
###############################################

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

#########################
# Routes and Route Tables
#########################

#find all route tables that are associated with the customer spoke VPC subnet
data "aws_route_table" "this" {
  provider = aws.protected
  for_each = data.aws_subnet_ids.this.ids
  subnet_id = each.value
}

#create routes for Valtix gateway services VPC CIDR in customer spoke VPC subnet route table
resource "aws_route" "this" {
  provider = aws.protected
  for_each = data.aws_subnet_ids.this.ids
  route_table_id            = data.aws_route_table.this[each.key].id
  destination_cidr_block    = var.is_egress == "true" ? local.egress_cidr : data.aws_vpc.gw.cidr_block
  transit_gateway_id = var.transit_gateway_id
}
