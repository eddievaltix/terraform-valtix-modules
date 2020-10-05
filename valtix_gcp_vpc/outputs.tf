output "mgmt_vpc_id" {
    value = google_compute_network.mgmt-vpc.self_link
}

output "datpath_vpc_id" {
    value = google_compute_network.datapath-vpc.self_link
}

output "mgmt_subnet_id" {
    value = google_compute_subnetwork.mgmt-subnet.self_link
}

output "datpath_subnet_id" {
    value = google_compute_subnetwork.datapath-subnet.self_link
}
