variable "gateway_vpc_name" {
    description = "Name of the Valtix gateway Services VPC"
}

variable "transit_gateway_id" {
    description = "Transit Gateway ID"
}

variable "s2svpn_cidr" {
    description = "CIDR of the Site to Site VPN tunnel for the routes format: x.x.x.x/y"
}