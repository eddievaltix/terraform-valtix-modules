This module is creates a demo VPC which consists of:
- 1 VPC
- 2 Public Subnets & 2 Private Subnets
- 1 Public SG & 1 Private SG
- 1 jump EC2 instance in Public Subnet & 1 backend instance per AZ in Private Subnet
- EC2 instances are running web services on port 80 with a Hello World html
- private key is injected into jump instances to ssh to the backend instances




