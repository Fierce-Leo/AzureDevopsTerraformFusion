# Welcome to Terraform + Azure Devops Assessment – Authored by Leo

This repository is structured into **three distinct directories**, each representing a key phase of the infrastructure-as-code implementation using **Terraform on Azure DevOps**.

---

## 📁 Directory Structure & Purpose

### 1️⃣ Bootstrap Resources Configuration

> **Purpose:** Lays the foundation for Terraform state management and initial Azure infrastructure setup.

- Deployed using **three separate pipelines** in Azure DevOps:
- This separation provides **greater control and traceability** over the early state bootstrapping.
- Ensures that remote backend (Azure Blob & KeyVault) is securely created before using it in production modules.

---

### 2️⃣ Master Resources Configuration

> **Purpose:** Deploys reusable modules and production-grade resources via a **single-multi-stage pipeline**.

- Uses a **modular Terraform structure** (App Service, SQL DB, Storage, etc.)
- Runs on **single-multi-stage DevOps YAML pipeline** with:
- Designed for **speed, scalability, and CI/CD best practices**.

---

### 3️⃣ Terraform Files Post `terraform mv`

> **Purpose:** Captures and documents changes after **refactoring state using `terraform state mv`**.

- Demonstrates how to:
  - Move resources (like Storage Accounts) from one module to another
  - Avoid resource recreation
  - Preserve state integrity
- Includes:
  - Updated Terraform module structure
  - Updated state addresses
  - **Documented runbook** of all `terraform state mv` steps

---

## ✅ Best Practices Followed

- Secure backend with **state locking** and **versioning**
- Secrets managed via **Azure Key Vault**
- Multi-region deployment using **maps** and **module for-each**
- Full use of **Azure DevOps Environments** for approvals
- Clear commit history with cleanup of any exposed secrets

---

Feel free to navigate through each folder to explore how Terraform and Azure DevOps were used together to achieve a robust, secure, and scalable IaC solution.

