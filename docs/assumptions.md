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


------------

- The PoC focuses on infrastructure patterns rather than full application functionality.
- Public access is temporarily enabled for PostgreSQL to reduce complexity in the first phase.
- High availability and private networking are deferred to a later phase.
- Small SKUs are intentionally selected to keep costs low during validation.
- Secrets are injected at deployment time rather than retrieved in-template due to ARM limitations.
