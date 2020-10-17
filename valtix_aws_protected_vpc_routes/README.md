This module updates the protected VPC subnet route tables for the Valtix gateway services VPC CIDR (or default route for Valtix Egress Gateway) to Transit Gateway.  It also creates the routes for Protected VPC Transit Gateway attachment route table.

Pre-requisite:
- Default AWS provider inhereited from root module is the account profile where the Transit Gateway was created. This is where the Transit Gateway Route Table will exist
- AWS Provider needs to be set in module with alias name = "protected" for account where VPC exists. This is where the Transit Gateway attachment will be made. Define this in your main.tf using the below block in the module:

  providers = {
    aws.protected = aws.<alias>
  }

