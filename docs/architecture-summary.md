## Current scope (PoC – in progress)

The current proof-of-concept establishes a minimal cloud foundation for NovaBank, focusing on:

- Separate **dev** and **prod** environments in Azure
- Centralised observability using **Log Analytics** and **Application Insights**
- Secure secret management using **Azure Key Vault** with RBAC
- Fully repeatable deployments using **Bicep** (no portal click-ops)



## Observability & auditability

Application and platform logs are centralised in Azure Log Analytics workspaces, with a dedicated workspace per environment (dev and prod).  
Application Insights is configured in workspace-based mode to ensure application telemetry is stored centrally with consistent retention.

Log retention is configured for 365 days to support audit and compliance requirements.


## Security (initial)

Secrets are stored in Azure Key Vault per environment.  
RBAC-based access control is used instead of access policies.

Public network access is temporarily enabled as a PoC trade-off and will be replaced by private endpoints in a next iteration.


# Data layer

Azure Database for PostgreSQL Flexible Server deployed in dev + prod (West Europe).

Small, cost-aware SKU (B1ms) for PoC; scale up later if needed.

Backups enabled (7-day retention) to support RPO requirements (with clear note: production tuning would follow).

HA not enabled (explicit PoC trade-off to keep complexity/cost low).

# Secrets

Postgres admin password stored in Key Vault per environment.

Note the important limitation + workaround:

“ARM/Bicep cannot read Key Vault secret values at deployment time; password is injected as a @secure() parameter during deployment (CLI/CI), sourced from Key Vault.”

# Networking

Public connectivity used for PoC; firewall rule allows Azure services.

“Next step: private endpoints + disable public access.”

# Application layer:


The application layer is hosted on Azure App Service (Linux) and deployed consistently across dev and prod environments using Infrastructure as Code.

App Service Plan + Web App deployed per environment.

Web App runtime configured as Node.js 18 (Linux) for the PoC.

HTTPS enforced by default.

Environment separation achieved via naming conventions and parameter files.

The Web App is configured with application settings that demonstrate:

Centralised observability via Application Insights

Database connectivity pattern via environment variables (no hardcoded secrets)



# High-Level Request Flow

1)User accesses the Web App via HTTPS.

2)Web App processes the request.

3)Application telemetry is sent to Application Insights.

4)Logs are stored centrally in Log Analytics.

5)(Future) Web App connects to PostgreSQL using injected connection settings.


# Alignment with CloudNation 6D Model

This first step aligns primarily with:

Discover & Define – understanding constraints, risks, and baseline requirements.

Design – selecting simple, defensible Azure services.

Deliver – repeatable deployments via IaC.

Reference: CloudNation 6D Model