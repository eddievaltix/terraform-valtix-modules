This module creates the Transit Gateway attachment and Transit Gateway attachment route table for a Valtix Protected VPC.  

Pre-requisite:
- Default AWS provider is the account profile where the Transit Gateway was created.  This is where the Transit Gateway Route Table will exist
- AWS Provider needs to be set in module with alias name = "protected" for account where VPC exists.  This is where the Transit Gateway attachment will be made. Define this in your main.tf using the below block in the module:

providers = {
    aws.protected = aws.<alias>
  }


