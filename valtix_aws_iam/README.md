This module is used to protect a VPC that exists in a different account.  This module will share the Transit Gateway from principal (customer AWS account).  It assumes that you have access to customer AWS account and have a AWS profile configured with access keys

## Terraform versions

Only Terraform 0.12 or newer is supported.

Requirement:
1. Two AWS profiles must be defined:
    - AWS account containing the centralized Valtix Gateways
    - AWS account containing VPC to protect
2. Subnets in the customer VPC that should be associated with the Transit Gateway VPC attachment must be tagged with valtix_tgw = "true"
3. Subnets must be in all AZs in the VPC


