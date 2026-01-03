
output "resource_group_name" {
  value = "rg-${var.project}-${var.env}"
}
output "log_analytics_workspace_id" {
  value = module.law.workspace.id
}

output "log_analytics_workspace_name" {
  value = module.law.workspace.name
}
