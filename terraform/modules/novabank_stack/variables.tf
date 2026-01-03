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

