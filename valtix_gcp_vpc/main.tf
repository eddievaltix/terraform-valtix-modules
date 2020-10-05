#Create mgmt VPC
resource "google_compute_network" "mgmt-vpc" {
  name                    = "mgmt-vpc"
  auto_create_subnetworks = false
}
#Create datapath VPC
resource "google_compute_network" "datapath-vpc" {
  name                    = "datapath-vpc"
  auto_create_subnetworks = false
}
#Create mgmt subnet
resource "google_compute_subnetwork" "mgmt-subnet" {
  name          = "mgmt-subnet"
  ip_cidr_range = var.mgmt_vpc_cidr
  region        = var.region
  network       = google_compute_network.mgmt-vpc.id
}
#Create datapath subnet
resource "google_compute_subnetwork" "datapath-subnet" {
  name          = "datapath-subnet"
  ip_cidr_range = var.datapath_vpc_cidr
  region        = var.region
  network       = google_compute_network.datapath-vpc.id
}