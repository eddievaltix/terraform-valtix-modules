output "valtix_controller_role_arn" {
    description = "this outputs the valtix-controller IAM role ARN"
    value = aws_iam_role.valtix_controller_role.arn
}