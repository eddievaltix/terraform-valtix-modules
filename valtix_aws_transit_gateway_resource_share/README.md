This module is used to share a Transit Gateway resource to external principals (accounts).  You must have a AWS default profile configured as well as a profile for the 
account for the protected VPC AWS account.  Define this in your main.tf using the below block in the module:

  providers = {
    aws.protected = aws.<alias>
  }

## Terraform versions

Only Terraform 0.12 or newer is supported.
