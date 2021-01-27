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

# AWS resources shared via Resource Access Manager can take a few seconds to
# propagate across AWS accounts after RAM returns a successful association.
resource "time_sleep" "ram_resource_propagation" {
  create_duration = "60s"

  triggers = {
    # This sets up a proper dependency on the RAM association
    tgw_resource_arn = aws_ram_principal_association.example.resource_arn
  }
}

#create a new principal association to the existing resource share
resource "aws_ram_principal_association" "this" {
  principal          = var.principal
  resource_share_arn = data.aws_ram_resource_share.this.arn
}

#accept the shared resource on the customer spoke VPC account
resource "aws_ram_resource_share_accepter" "this" {
  provider  = aws.protected
  share_arn = [time_sleep.ram_resource_propagation.triggers["tgw_resource_arn"]]
}
