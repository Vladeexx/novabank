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


//////////////////////////////////////// ###   Application Insights

module "appi" {
  source  = "CloudNationHQ/appi/azure"
  version = "3.0.1"

  config = {
    name                = "appi-${var.project}-${var.env}"
    location            = var.location
    resource_group_name = "rg-${var.project}-${var.env}"

    application_type = "web"

    # workspace-based mode:
    workspace_id = module.law.workspace.id

    tags = var.tags
  }
}

/////////////////////////////////////// ## Key Vault

data "azurerm_client_config" "current" {}

module "kv" {
  source  = "CloudNationHQ/kv/azure"
  version = "4.3.0"

  vault = {
    name                = "kv-${var.project}-${var.env}-01"
    location            = var.location
    resource_group_name = "rg-${var.project}-${var.env}"
    tenant_id           = data.azurerm_client_config.current.tenant_id

    rbac_authorization_enabled = true

    admins = [
      data.azurerm_client_config.current.object_id
    ]

    tags = var.tags
  }
}

///////////////////////////////////////////// App Service Plan

module "plan" {
  source  = "CloudNationHQ/plan/azure"
  version = "3.0.0"

  plans = {
    app = {
      name                = "plan-${var.project}-${var.env}"
      os_type             = "Linux"
      sku_name            = "B1"
      resource_group_name = "rg-${var.project}-${var.env}"
      location            = var.location
      tags                = var.tags
    }
  }
}


/////////////////////////////////////////////





