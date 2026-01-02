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