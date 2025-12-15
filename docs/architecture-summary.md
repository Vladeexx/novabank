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
