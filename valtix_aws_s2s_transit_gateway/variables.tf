variable "transit_gateway_id" {
  description = "ID of the transit gateway where VPN conn is made"
}

variable "customer_gateway_ip" {
  description = "External IP address for customer gateway"
}

variable "customer_gateway_name" {
  description = "Name tag for customer gateway"
}

variable "bgp_asn" {
  description = "this is the customer gateway BGP ASN"
  default = "65000"
}

variable "gateway_vpc_name" {
  description = "name of the gateway vpc"
}