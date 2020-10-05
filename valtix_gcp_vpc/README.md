This TF template creates GCP VPCs for Valtix gateway deployments.  This creates:
- mgmt VPC - can be shared my multiple gateways
- datapath VPC - used for ingress gateways where applications can reside
- egress VPC - used for egress gateways
