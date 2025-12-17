## Observability

This project includes a basic observability setup to provide centralized logging,
metrics, and application-level telemetry.

### What gets created

For each environment (**dev** and **prod**), the deployment creates:

- A **Log Analytics Workspace**
- An **Application Insights** instance linked to that workspace

These resources provide centralized logging, metrics, and application telemetry
for the platform.

---

### Where logs live

- All logs and metrics are stored in an **Azure Log Analytics Workspace**
- **Application Insights** sends telemetry such as:
  - HTTP requests
  - Dependencies
  - Exceptions

The workspace acts as the **single source of truth** for observability data.

---

### Log retention

- Log retention is configured to **365 days**
- This supports:
  - Troubleshooting
  - Auditing
  - Historical analysis

Retention can be adjusted later based on **cost** or **compliance requirements**.

---

### Access control

- Access to observability resources is currently controlled via **Azure RBAC**
- Permissions will be **tightened further** as the platform matures

## What is deployed so far

- Log Analytics workspace (dev & prod)
- Application Insights (workspace-based)
- Azure Key Vault with RBAC
- Example secret stored per environment

All resources are deployed using Bicep and Azure CLI.

## Pre-deployment validation (what-if)

az deployment group what-if \
  --resource-group rg-novabank-dev-weu \
  --template-file iac/main.bicep \
  --parameters iac/dev.bicepparam

## Deployment execution (script)

./deploy.sh dev
./deploy.sh prod


## Deployment validation

The deployment approach was validated in multiple steps:

1. **Pre-deployment preview**  
   Azure Resource Manager `what-if` was used to validate the template and preview changes before deployment, ensuring no unintended modifications.

2. **Scripted deployment execution**  
   The infrastructure was deployed using a Bash script that wraps the Azure CLI. The same script was executed for both dev and prod environments.

3. **Post-deployment verification**  
   Deployed resources were verified using Azure CLI commands and the Azure Portal to confirm correct resource creation, naming, and environment separation.

4. **Idempotency check**  
   The deployment script was re-run against the same environment to confirm idempotent behavior (no duplicate resources and no unintended changes).

   ## What is deployed so far
- Log Analytics workspace (dev & prod)
- Application Insights (workspace-based)
- Key Vault (RBAC) (dev & prod)
- PostgreSQL Flexible Server (dev & prod)

## Deploy Postgres (prod)
Fetch password from Key Vault and inject as secure parameter:
```bash
PG_PASS=$(az keyvault secret show --vault-name kv-novabank-prod --name DbAdminPassword --query value -o tsv)
az deployment group create --resource-group rg-novabank-prod-weu --template-file iac/main.bicep --parameters iac/prod.bicepparam --parameters pgAdminPassword="$PG_PASS" --name nb-prod-postgres
unset PG_PASS



