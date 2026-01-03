///////////////////////////////////////// #### RG module

module "rg" {
  source  = "CloudNationHQ/rg/azure"
  version = "2.7.0"

  groups = {
    core = {
      name     = "rg-${var.project}-${var.env}"
      location = var.location
      tags     = var.tags
    }
  }
}

//////////////////////////////////////// ####  Log Analytic module ###

module "law" {
  source  = "CloudNationHQ/law/azure"
  version = "3.2.0"

  tags = var.tags

  workspace = {
    name                = "law-${var.project}-${var.env}"
    location            = var.location
    resource_group_name = "rg-${var.project}-${var.env}"
    retention           = var.log_analytics_retention_days
  }
}



