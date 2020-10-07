output "attachment_id" {
    description = "this is the protected VPC Transit Gateway attachment ID"
    value = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "attachment_route_table_id" {
    description = "this is the protected VPC Transit Gateway attachment route table ID"
    value = aws_ec2_transit_gateway_route_table.this.id
}