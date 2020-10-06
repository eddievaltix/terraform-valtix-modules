output "vpn_conn_id" {
    description = "outputs the site to site ipsec tunnel connection id"
    value = aws_vpn_connection.it.id
}