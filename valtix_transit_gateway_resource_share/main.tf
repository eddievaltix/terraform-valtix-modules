provider "aws" {
  alias = "protected"
}

#########################
# Resource Access Manager
#########################
#find the resource share in the transit account
data "aws_ram_resource_share" "this" {
  name           = var.resource_share_name
  resource_owner = "SELF"
}

#create a new principal association to the existing resource share
resource "aws_ram_principal_association" "this" {
  principal          = var.principal
  resource_share_arn = data.aws_ram_resource_share.this.arn
}

#accept the shared resource on the customer spoke VPC account
resource "aws_ram_resource_share_accepter" "this" {
  provider  = aws.protected
  share_arn = aws_ram_principal_association.this.resource_share_arn
  depends_on = [aws_ram_principal_association.this]
}
