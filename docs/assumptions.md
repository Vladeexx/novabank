## Assumptions

- Initial workload size is small and suitable for PaaS services.
- NovaBank accepts a phased security approach, with private networking implemented in a later iteration.
- No immediate requirement for multi-region active/active deployment.
- Azure is an acceptable cloud provider for the first migration phase.
- Development and production environments must remain isolated.

------------

- PoC uses public access for PostgreSQL to keep scope minimal; will move to Private Endpoint later.

- HA not enabled for PoC; would be considered to meet availability targets.

- Backup retention set to 7 days for PoC; production may require longer retention depending on policy.