# Azure Migration – Terraform (Modular, Map-driven, Reusable)

This repository provisions an **Azure App Service**, **Azure SQL (server + DB)**, and **four Storage Accounts** in **two regions**: **WE (West Europe)** and **NS (North Europe)**. It uses:
- **Modules** and a **map**-driven multi-region pattern
- **Remote state** in Azure Blob with versioning/soft delete (via a separate bootstrap step)
- **Key Vault** for secrets (SQL admin password & connection string)
- **Logging**, **validation**, and **least-privilege** guidance

---

## Prerequsites

- Terraform v1.5+
- Azure CLI logged in, or a Service Principal configured via env vars:
  - `ARM_CLIENT_ID` / `ARM_CLIENT_SECRET` / `ARM_TENANT_ID` / `ARM_SUBSCRIPTION_ID`
- A **Key Vault** that stores the **`sql-admin-password`** and **`db-connection-string`** secrets.
  - You can also create Key Vault using the optional module described below.

---

## Quick Start

1) **Bootstrap the remote state backend (one-time):**

```bash
cd bootstrap/tfstate
terraform init
terraform apply -auto-approve
```

This creates a RG + Storage Account + Container with versioning and soft delete enabled.
Copy the output values and paste them into the root `backend.tf` (or export as TF_VARs).

2) **Deploy the workload (multi-region):**

```bash
cd ../../
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=env/we.tfvars -var-file=env/ns.tfvars -out=plan.out
TF_LOG=DEBUG terraform apply plan.out
```

---

## Structure

```
azure-migration/
├── README.md
├── TROUBLESHOOTING.md
├── MODULES.md
├── provider.tf
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── env/
│   ├── we.tfvars
│   └── ns.tfvars
├── modules/
│   ├── rg/
│   │   └── main.tf
│   ├── network/
│   │   └── main.tf
│   ├── sql/
│   │   └── main.tf
│   ├── appservice/
│   │   └── main.tf
│   └── storage/
│       └── main.tf
└── bootstrap/
    └── tfstate/
        ├── main.tf
        └── variables.tf
```

---

## Notes on App Service ↔ SQL via Service Endpoint

Azure SQL supports **service endpoints** on a **subnet** in a **VNet**. App Service integrates with that subnet (VNet integration).  
This project creates a VNet/Subnet with the **`Microsoft.Sql`** service endpoint enabled and attaches the **Web App** to that subnet.


## Validation & Logging

```bash
terraform fmt -recursive
terraform validate
TF_LOG=DEBUG terraform plan -out=plan.out
TF_LOG=TRACE terraform apply plan.out
```

---

## Least Privilege

Grant your deployment identity:
- **Contributor** on the target RG(s) (or narrower, e.g., specific resource types)
- **Key Vault Secrets User** on the Key Vault
- Optionally, Reader/Network Contributor on VNet if separated

---

## Optional Key Vault Creation

If you need to create a Key Vault, add (or extend) a `modules/keyvault` later and wire in outputs. For this exercise we assume it exists and only **read** secrets via data sources.

