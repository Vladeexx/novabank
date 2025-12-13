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
