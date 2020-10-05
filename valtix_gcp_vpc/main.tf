#Create mgmt VPC
resource "google_compute_network" "mgmt-vpc" {
  name                    = var.mgmt_vpc_name
  auto_create_subnetworks = false
}
#Create datapath VPC
resource "google_compute_network" "datapath-vpc" {
  name                    = var.datapath_vpc_name
  auto_create_subnetworks = false
}

#Create egress VPC
resource "google_compute_network" "egress-vpc" {
  name                    = var.egress_vpc_name
  auto_create_subnetworks = false
} 

#Create mgmt subnet
resource "google_compute_subnetwork" "mgmt-subnet" {
  name          = var.mgmt_subnet_name
  ip_cidr_range = var.mgmt_subnet_cidr
  region        = var.region
  network       = google_compute_network.mgmt-vpc.id
}

#Create datapath subnet
resource "google_compute_subnetwork" "datapath-subnet" {
  name          = var.datapath_subnet_name
  ip_cidr_range = var.datapath_subnet_cidr
  region        = var.region
  network       = google_compute_network.datapath-vpc.id
}

#Create datapath subnet
resource "google_compute_subnetwork" "egress-subnet" {
  name          = var.egress_subnet_name
  ip_cidr_range = var.egress_subnet_cidr
  region        = var.region
  network       = google_compute_network.egress-vpc.id
}