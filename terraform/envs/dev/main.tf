module "stack" {
  source = "../../modules/novabank_stack"

  project  = "novabank"
  env      = "dev"
  location = "westeurope"
  
  log_analytics_retention_days = 30

  tags = {
    Environment = "dev"
    Workload    = "novabank"
    ManagedBy   = "Terraform"
    Owner       = "Vlad"
  }

  psql_admin_login    = "psqladmin"
  psql_admin_password = var.psql_admin_password

  
}

output "psql_fqdn" {
  description = "PostgreSQL Flexible Server FQDN"
  value       = module.stack.psql_fqdn
}
