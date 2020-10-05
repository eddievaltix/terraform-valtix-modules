output "mgmt_vpc_id" {
    value = google_compute_network.mgmt-vpc.self_link
}

output "datapath_vpc_id" {
    value = google_compute_network.datapath-vpc.self_link
}

output "egress_vpc_id" {
    value = google_compute_network.egress-vpc.self_link
}

output "mgmt_subnet_id" {
    value = google_compute_subnetwork.mgmt-subnet.self_link
}

output "datapath_subnet_id" {
    value = google_compute_subnetwork.datapath-subnet.self_link
}

output "egress_subnet_id" {
    value = google_compute_subnetwork.egress-subnet.self_link
}

