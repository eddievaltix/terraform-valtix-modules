########################################################
# DATA SOURCE FOR TRANSIT GATEWAY and VPC\VPN ATTACHMENT
########################################################

data "aws_ec2_transit_gateway" "it" {
  filter {
    name = "tag:Name"
    values = [var.transit_gateway_name]
  }
}

data "aws_ec2_transit_gateway_vpn_attachment" "it" {
  transit_gateway_id = data.aws_ec2_transit_gateway.it.id
  vpn_connection_id  = aws_vpn_connection.it.id
}

data "aws_vpc" "it" {
  tags = {
    Name=var.gateway_vpc_name
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "it" {
   filter {
    name   = "vpc-id"
    values = [data.aws_vpc.it.id]
  }
} 

###############################
# CUSTOMER GATEWAY and S2S CONN
###############################

resource "aws_customer_gateway" "it" {
  bgp_asn    = var.bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
  tags = {
    Name = var.customer_gateway_name
  }
}

resource "aws_vpn_connection" "it" {
  customer_gateway_id = aws_customer_gateway.it.id
  transit_gateway_id  = data.aws_ec2_transit_gateway.it.id
  type                = aws_customer_gateway.it.type
  static_routes_only  = true
  tags = {
    Name = var.customer_gateway_name
  }
}

resource "aws_ec2_transit_gateway_route_table" "it" {
  transit_gateway_id = data.aws_ec2_transit_gateway.it.id
  tags = {
    Name = var.customer_gateway_name
  }
}

resource "aws_ec2_transit_gateway_route" "tgw-route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.it.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.it.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_assoc" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpn_attachment.it.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.it.id
}









