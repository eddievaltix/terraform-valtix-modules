resource "valtix_cloud_account" this {
  name                     = var.valtix_cloud_account_name
  csp_type                 = "AWS"
  aws_credentials_type     = "AWS_IAM_ROLE"
  aws_iam_role             = var.valtix_cloud_account_iam_role
  aws_account_number       = var.valtix_cloud_account_account_number
  aws_iam_role_external_id = var.valtix_cloud_account_external_id
  inventory_monitoring {
    regions = var.inventory_regions
    refresh_interval = "60"
  }
} 