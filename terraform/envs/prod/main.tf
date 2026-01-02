module "stack" {
  source = "../../modules/novabank_stack"

  project  = "novabank"
  env      = "prod"
  location = "westeurope"

  tags = {
    Environment = "prod"
    Workload    = "novabank"
    ManagedBy   = "Terraform"
    Owner       = "Vlad"
  }
}
