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


