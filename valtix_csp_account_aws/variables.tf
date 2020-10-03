variable "valtix_cloud_account_name" {
  description = "CSP Account name added to the valtix controller"
}

variable "valtix_cloud_account_iam_role" {
  description = "CSP Account name added to the valtix controller"
}

variable "valtix_cloud_account_account_number" {
  description = "CSP Account name added to the valtix controller"
}

variable "valtix_cloud_account_external_id" {
  description = "CSP Account name added to the valtix controller"
}

variable "inventory_regions" { 
  description = "List of regions to enable inventory"
  default = ["us-east-1"]
}