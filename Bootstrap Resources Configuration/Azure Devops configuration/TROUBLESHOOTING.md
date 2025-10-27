# Troubleshooting

## Common Failures & Issues that can occur during deployments

### Name already taken (Storage Accounts/Web Apps)
- Azure requires **globally unique** names. This repo uses a random suffix. If collisions still occur, remove `.terraform/` and re-apply or adjust the prefix locally.

### Key Vault access
- Ensure the identity running Terraform has **Key Vault Secrets User** and that firewall/privates endpoints allow access.

### App Service VNet integration
- You must deploy to an App Service Plan that supports VNet integration (Basic+ is ok for regional VNet integration). If you change SKU, plan recreation may occur.
- Confirm the subnet has **service endpoint** `Microsoft.Sql` enabled.

### SQL Connectivity
- Verify the connection string stored in Key Vault is correct.
- Optionally allow Azure services on the server (firewall rule), or prefer private networking.

### Provider issues / timeouts
- Re-run with `TF_LOG=DEBUG` and inspect detailed logs.
- Use `terraform state list` to confirm resource addresses.
- If a module refactor changed addresses, use `terraform state mv` to align state to code.

### Virtual Network
- Provide unique addresses & CIDR for Vnet & Subnet to avoid overlapping in Future
- Make sure to delegate the subnet for WebApp Vnet Integration else Azure blocks the web app from using the subnet for VNet integration.