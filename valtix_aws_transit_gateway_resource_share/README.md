This module is used to share a Transit Gateway resource to external principals (accounts).  

Pre-requisite:

- You must have a AWS default profile configured that is inherited from the root module.  This AWS profile points to the AWS account where the Transit Gateway you wish to share exists.

- You must have another AWS profile created for accessing the account where the Transit Gateway should be shared.  Define this in your main.tf using the below block in the module:

  providers = {
    aws.protected = aws.<alias>
  }

