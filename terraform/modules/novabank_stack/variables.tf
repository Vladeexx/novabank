variable "project"  { type = string }
variable "env"      { type = string }
variable "location" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
// ----------------------------------------------

variable "log_analytics_retention_days" {
  type        = number
  description = "Log Analytics retention in days (dev 30, prod 365)."
}

// ----------------------------------------------

variable "psql_admin_login" {
  type        = string
  description = "PostgreSQL admin login for Flexible Server."
  default     = "psqladmin"
}

variable "psql_admin_password" {
  type        = string
  description = "PostgreSQL admin password"
  sensitive   = true
}


