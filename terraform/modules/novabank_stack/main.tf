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


///////////////////////////////////////////// App Service


module "app" {
  source  = "CloudNationHQ/app/azure"
  version = "5.0.0"

  instance = {
    name                = "app-${var.project}-${var.env}"
    type                = "linux"
    location            = var.location
    resource_group_name = "rg-${var.project}-${var.env}"

    service_plan_id = module.plan.plans.app.id

    identity = {
      type = "SystemAssigned"
    }

    app_settings = {
      # App Insights
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.appi.config.connection_string
    }

    site_config = {
      always_on            = true
      ftps_state           = "Disabled"
      minimum_tls_version  = "1.2"

      application_stack = {
        node_version = "20-lts"
      }
    }

    tags = var.tags
  }
}


///////////////////////////////////////////// Data block


data "azurerm_key_vault" "kv" {
  name                = "kv-${var.project}-${var.env}-01"
  resource_group_name = "rg-${var.project}-${var.env}"
  depends_on          = [module.kv]
}

data "azurerm_linux_web_app" "app" {
  name                = "app-${var.project}-${var.env}"
  resource_group_name = "rg-${var.project}-${var.env}"
  depends_on          = [module.app]
}


/////////////////////////////////////////////  RBAC


resource "azurerm_role_assignment" "app_to_kv_secrets_user" {
  scope              = data.azurerm_key_vault.kv.id
  role_definition_id = "/subscriptions/4f8cfe93-e6dd-4f13-a6bd-311131073c9a/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6"
  principal_id       = data.azurerm_linux_web_app.app.identity[0].principal_id
}






