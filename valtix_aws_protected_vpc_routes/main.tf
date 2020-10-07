locals {
  egress_cidr = "0.0.0.0/0"
}

provider "aws" {
  alias = "protected"
}

###############################################
# Transit Gateway and Protected VPC Data Source
###############################################

data "aws_vpc" "gw" {
  tags = {
    Name = var.valtix_gateway_vpc_name
  }
}

#######################################
# Protected VPC Routes and Route Tables
#######################################

#find all route tables that are associated with the customer spoke VPC subnet
data "aws_route_table" "this" {
  provider = aws.protected
  for_each = var.protected_vpc_subnet_ids
  subnet_id = each.value
}

#create routes for Valtix gateway services VPC CIDR in customer spoke VPC subnet route table
resource "aws_route" "this" {
  provider               = aws.protected
  #for_each               = data.aws_subnet_ids.this.ids
  for_each = var.protected_vpc_subnet_ids
  route_table_id         = data.aws_route_table.this[each.key].id
  destination_cidr_block = var.is_egress == "true" ? local.egress_cidr : data.aws_vpc.gw.cidr_block
  transit_gateway_id     = var.transit_gateway_id
}

####################################################################################
# Creating the Transit Gateway Protected VPC attachment route to Valtix Services VPC
####################################################################################

#find gateway vpc attachment resource so we can add it to the protected vpc attachment route table
data "aws_ec2_transit_gateway_vpc_attachment" "gw" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.gw.id]
  }
}

#create the transit gateway route for the protected vpc attachment route table
resource "aws_ec2_transit_gateway_route" "this" {
  destination_cidr_block         = var.is_egress == "true" ? local.egress_cidr : data.aws_vpc.gw.cidr_block
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.gw.id
  transit_gateway_route_table_id = var.protected_vpc_attachment_route_table_id
}
