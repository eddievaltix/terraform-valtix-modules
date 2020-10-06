########################################################
# DATA SOURCE FOR TRANSIT GATEWAY and VPC\VPN ATTACHMENT
########################################################
data "aws_ec2_transit_gateway" "it" {
  id = var.transit_gateway_id
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

#find the Valtix datapath subnet route tables
data "aws_route_tables" it {
  tags = {
    #Name = "${var.gateway_vpc_name}-datapath*"
    Name = "quipux-VALTIXEASTWEST-datapath-us-east-1a-rt"
  }
}


data "aws_ec2_transit_gateway_route_table" "it" {
  filter {
    name   = "transit-gateway-id"
    values = [var.transit_gateway_id]
  }
  tags = {
    Name = var.gateway_vpc_name
  }
}

/*
#find the Valtix Services Transit Gateway VPC attachment route table
data "aws_ec2_transit_gateway_route_table" "it" {
  filter {
    name   = "transit-gateway-id"
    values = [var.transit_gateway_id]
  }
    #transit_gateway_id = data.aws_ec2_transit_gateway.it.id
  tags = {
    Name = var.gateway_vpc_name
  }
}
*/
#######################################################################################
# Route Addition in Valtix Datapath Subnet & Transit Gateway VPC attachment route table
#######################################################################################
resource "aws_route" "it" {
  count                   = length(data.aws_route_tables.it.ids)
  route_table_id          = data.aws_route_tables.it.ids[count.index]
  destination_cidr_block  = var.s2svpn_cidr
  transit_gateway_id      = var.transit_gateway_id
}

resource "aws_ec2_transit_gateway_route" "it" {
  destination_cidr_block         = var.s2svpn_cidr
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.it.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.it.id
}