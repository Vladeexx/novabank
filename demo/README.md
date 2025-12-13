Observability
What gets created:

For each environment (dev and prod), the deployment creates:

A Log Analytics Workspace

An Application Insights instance linked to that workspace

These resources provide centralized logging, metrics, and application-level telemetry.

Where logs live

All logs and metrics are stored in an Azure Log Analytics Workspace.

Application Insights sends telemetry (requests, dependencies, exceptions) to this workspace

The workspace acts as the single source of truth for observability data

Log retention

Log retention is configured to 365 days

This supports troubleshooting, auditing, and historical analysis

Retention can be adjusted later based on cost or compliance requirements

Access & security

Access to Log Analytics and Application Insights is controlled via Azure RBAC

Currently, access is restricted at the resource level

RBAC will be tightened further in later phases to follow least-privilege principles

in short:

Observability is implemented using Azure-native services, providing centralized logging and application insights with defined retention and RBAC-based access control.

