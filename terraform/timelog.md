## Time log – Infrastructure as Code (Terraform)

**Date:** 2026-01-02  
**Duration:** 6 hours  

### Activity
Initial Terraform setup and Azure infrastructure foundation (dev & prod)

### Description
- Installed and configured Terraform on macOS  
- Set up Azure authentication and verified correct subscription context  
- Designed Terraform project structure with reusable modules and separate dev/prod environments  
- Implemented the first Infrastructure as Code module (Azure Resource Group)  
- Resolved AzureRM provider configuration issues and Azure resource provider registration constraints  
- Validated Terraform workflow (`init`, `plan`, `apply`) end-to-end  
- Deployed Azure Resource Groups for **dev** and **prod** using the same module with environment-specific parameters  
- Built hands-on understanding of Terraform state management, provider behavior, and Azure platform prerequisites  

### Notes
Time includes initial learning curve, environment setup, troubleshooting provider registration behavior, and validating a clean, repeatable IaC foundation before continuing with additional infrastructure components.



------------------------------------



**Duration:** 1 hour  

### Activity
Git repository cleanup and push issue resolution

### Description
- Investigated GitHub push failure caused by large Terraform provider binaries  
- Added Terraform-specific `.gitignore` rules  
- Removed cached `.terraform` directories from version control  
- Cleaned Git history using `git filter-repo` and restored remote configuration  
- Verified repository state and ensured future Terraform runs do not pollute Git history  

### Notes
Work was required to unblock repository submission



--------------------------------------



## Time log – Terraform refactor to CloudNation modules

**Duration:** 2 hours  

### Activity
Aligning Terraform deployment with CloudNation Well-Architected Modules standards

### Description
- Reviewed CloudNation Well-Architected Modules documentation and Terraform resource modules  
- Refactored Resource Group deployment to use the CloudNation RG Terraform module  
- Updated provider versions and subscription configuration to align with module requirements  
- Added standardized tagging and environment-specific parameters  
- Validated deployment via Terraform plan for dev environment  

### Notes
Work focused on aligning the Infrastructure as Code approach with CloudNation standards while keeping the existing pattern module structure intact.



-----------------------------



## Time log – Terraform logging foundation (CloudNation WAM)

**Date:** 2026-01-03  
**Duration:** 4 hours  

### Activity
Implementing centralized logging using CloudNation Terraform modules

### Description
- Deployed Log Analytics Workspace for dev and prod using CloudNation WAM resource module  
- Integrated LAW into existing pattern module (`novabank_stack`)  
- Configured environment-specific retention (dev: 30 days, prod: 365 days)  
- Resolved Terraform version compatibility and module validation issues  
- Verified resources and tagging in Azure Portal  

### Outcome
Centralized logging foundation successfully established and aligned with CloudNation Well-Architected Modules standards.




-------------------------------------------------




## Time log – Application Insights deployment (CloudNation WAM)

**Date:** 2026-01-04  
**Duration:** 2 hours  

### Activity
Deploying Application Insights using CloudNation Terraform module

### Description
- Integrated CloudNation Application Insights resource module into pattern module  
- Configured workspace-based Application Insights connected to Log Analytics Workspace  
- Exposed Application Insights outputs for future App Service integration  
- Deployed and verified Application Insights for dev and prod environments  



## Time log – Key Vault deployment (CloudNation WAM)

**Duration:** 2 hours  

### Activity
Deploying Azure Key Vault using CloudNation Terraform module

### Description
- Integrated CloudNation Key Vault module into pattern module  
- Enabled RBAC-based access control and admin assignment  
- Aligned Key Vault with existing resource group and naming conventions  
- Resolved soft-delete recovery issue during deployment  
- Deployed and verified Key Vault for dev environment  



--------------------------------------------



## Time log – App Service Plan deployment

**Date:** 2026-01-07  
**Duration:** 1 hour  

### Activity
Deploying App Service Plan using CloudNation Terraform module

### Description
- Integrated CloudNation App Service Plan module into reusable stack  
- Configured Linux based plan with B1 SKU for dev and prod hosting  
- Aligned plan to existing resource group structure and tags  
- Exposed plan ID outputs for upcoming App Service deployment

--->

## Time log – App Service deployment (CloudNation WAM)

**Duration:** 2 hours  

### Activity
Deploying App Service using CloudNation Terraform module

### Description
- Integrated CloudNation App Service module into existing stack  
- Configured Linux Web App connected to App Service Plan compute layer  
- Enabled System Assigned Managed Identity for passwordless security baseline  
- Wired application platform to Application Insights for monitoring  
- Configured core app settings and TLS compliance (1.2, HTTPS)  
- Deployed and validated Web App for dev and prod environments via Terraform plan/apply

----------->

## Time log – App Service → Key Vault security setup

**Duration:** 2 hours  

### Activity
Configuring access from the NovaBank Web App to Azure Key Vault

### What happened
I initially attempted to use the CloudNationHQ/rbac/azure module to create the role assignment. The idea was good: keep everything standardized through CloudNation modules. However, that module relies on **dynamic lookups** of built-in Azure roles using the Authorization and Entra ID APIs. In my environment those lookup steps became stuck, which prevented Terraform from finishing even the *plan* phase.

### How I fixed it
Instead of fighting the module internals, I chose a pragmatic path. I used the **native AzureRM Terraform resource `azurerm_role_assignment`** and passed the verified role definition ID for *Key Vault Secrets User* that I retrieved once with Azure CLI. This allowed Terraform to create the assignment directly and quickly, while still keeping the solution fully auditable and managed as part of our own IaC pattern.

### Result
The Web App’s **system-assigned managed identity** now has permission to *list and read* secrets from Key Vault. The application can consume sensitive settings without any hardcoded passwords, and the platform is ready for the next component — deploying the PostgreSQL database and wiring it to the app through Key Vault references.  


------------------------------------------

Time log – PostgreSQL, Key Vault secrets & application connectivity (PoC)

Date: 2026-01-08
Duration: 6 hours

## Activity

Deploying PostgreSQL Flexible Server and wiring secure application connectivity via Azure Key Vault

## Description

- Integrated CloudNation PostgreSQL Flexible Server Terraform module into the reusable NovaBank stack
- Deployed PostgreSQL Flexible Server (v16) with a dedicated application database for dev and prod environments
- Configured baseline storage, backup retention, and TLS-secured connections aligned with platform standards
- Key Vault & secrets integration
- Prepared Key Vault for application configuration by defining database-related secrets (host, name, user, password)
- Configured the Web App to reference database settings using Key Vault references in App Service configuration
- Validated that secrets are resolved at runtime via the Web App’s system-assigned managed identity, without hardcoding secret values in Terraform code.
- Ensured Terraform manages references and permissions, while secret values remain external and replaceable

## Connectivity & security decisions

- Enabled public network access on PostgreSQL intentionally for PoC allowing Azure platform traffic only (Azure services rule)
- Verified that the database is not accessible from arbitrary public IP addresses
- Avoided early complexity such as VNet integration or private endpoints, keeping a clear Phase-2 hardening path

## What was intentionally deferred

Restricting PostgreSQL access to App Service outbound IPs
Private Endpoint and VNet-based database connectivity
Advanced high-availability and geo-redundant backup configuration

# Result

The NovaBank application stack now includes a functional PostgreSQL backend and a secure secret delivery mechanism using Azure Key Vault.
The Web App can retrieve database configuration securely at runtime without hardcoded credentials, and both dev and prod environments are fully deployed, auditable, and ready for further application work or future security hardening.