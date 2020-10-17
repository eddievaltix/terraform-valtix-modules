output "valtix_controller_role_arn" {
    description = "this outputs the valtix-controller IAM role ARN"
    value = aws_iam_role.valtix_controller_role.arn
}

output "valtix_firewall_role_name" {
    description = "this outputs the name of the Valtix firewall role"
    value = aws_iam_role.valtix_fw_role.name
}