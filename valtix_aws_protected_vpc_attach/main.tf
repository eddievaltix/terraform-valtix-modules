provider "aws" {
  alias = "protected"
}

#create the protected VPC attachment to transit gateway in the protected VPC account
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  provider           = aws.protected
  subnet_ids = var.protected_vpc_subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.protected_vpc_id
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"
  tags = {
    Name = "valtix-${var.valtix_cloud_account_name}-${var.protected_vpc_name}"
  }
}

#create the route table for the protected VPC attachment
resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.transit_gateway_id
  tags = {
    Name = "valtix-${var.valtix_cloud_account_name}-${var.protected_vpc_name}"
  }
}

#associate the protected vpc attachment transit gateway route table to the protected vpc attachment using created resource
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}