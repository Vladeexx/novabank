module "stack" {
  source = "../../modules/novabank_stack"

  project  = "novabank"
  env      = "dev"
  location = "westeurope"

  tags = {
    Environment = "dev"
    Workload    = "novabank"
    ManagedBy   = "Terraform"
    Owner       = "Vlad"
  }
}
