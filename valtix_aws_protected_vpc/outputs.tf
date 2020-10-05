output "transit_gateway_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "transit_gateway_vpc_attachment_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.this.id
}