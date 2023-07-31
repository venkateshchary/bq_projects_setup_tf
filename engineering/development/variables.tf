variable "dev_rbac_group" {
  type        = string
  description = "The deploper rbac group"
}

variable "viewer_user_rbac_group" {
  type        = string
  description = "The viewer rbac group"
}

variable "main_location" {
  type        = string
  description = "The main region for deployment"
  default     = "us-central1"
}
