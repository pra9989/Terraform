1. What are the key features of Terraform? \
Infrastructure as Code \
Execution plans \
Resource graph \
Change automation \
Multi-cloud support (AWS, Azure, GCP) \
2.What is a provider in Terraform? \
A provider is a plugin that allows Terraform to interact with APIs of cloud platforms like: \
AWS, Azure,GCP \
Example: \
provider "aws" { \
  region = "us-east-1" \
} \
3. What is a resource in Terraform? \
A resource represents an infrastructure component. \
4.What is Terraform state? \
Terraform state is a file (terraform.tfstate) that tracks: \
Resource mappings \
Metadata \
Dependencies \
5.What are remote backends? \
Used to store state remotely (important for teams). \
Examples: \
S3 + DynamoDB (AWS) \
Azure Storage \
GCS \
6.What is state locking? \
Prevents multiple users from modifying state at the same time. \
7.What are modules in Terraform? \
Reusable, organized collections of Terraform code. \
Example: \
module "vpc" { \
  source = "./modules/vpc" \
} \
8.Difference between count and for_each? \
| Feature  | count               | for_each         | \
| -------- | ------------------- | ---------------- | \
| Input    | number              | map/set          | \
| Use case | identical resources | unique resources | \
| Indexing | numeric             | key-based        | \
Advanced Terraform Questions \
9.How does Terraform handle dependency graph? \
Terraform builds a DAG (Directed Acyclic Graph) and executes resources in parallel where possible. \
10.What is taint and untaint? \
taint: marks resource for recreation \
untaint: removes that mark \
11.What are provisioners? Are they recommended? \
Provisioners execute scripts (local/remote), but: \
👉 Not recommended for most use cases (use config management tools instead) \
12.What is lifecycle block? \
Controls resource behavior: \
lifecycle { \
  prevent_destroy = true \
  create_before_destroy = true \
} \
13.How do you manage secrets in Terraform? \
Environment variables \
Vault (e.g., HashiCorp Vault) \
Avoid hardcoding \
14.What is workspaces in Terraform? \
Used to manage multiple environments (dev, prod). \
15.How do you structure Terraform code for large projects? \
Typical structure: \
/modules \
/envs \
  /dev \
  /prod \
16.How do you implement CI/CD for Terraform? \
Use tools like: \
Jenkins \
GitHub Actions \
Steps: \
validate \
plan \
approval \
apply \
17.How do you debug Terraform issues? \
terraform plan \
terraform state list \
Logs (TF_LOG=DEBUG) \
18.What happens if Terraform state is lost? \
Infrastructure still exists \
Terraform loses tracking \
Solution: import resources again \
19.How do you handle drift? \
terraform plan \
terraform refresh (or refresh during plan) \
Re-apply configuration \
 \
Pro-Level Questions (Platform Engineering) \
20.How would you design Terraform for multi-tenant Kubernetes clusters? \
Separate state per tenant \
Modules for cluster provisioning \
RBAC + namespace isolation \
21.How do you integrate Terraform with Kubernetes? \
Kubernetes provider \
Helm provider \
Manage cluster + workload \
22.How do you secure Terraform in enterprise environments? \
Remote backend with encryption \
23.How do you implement DR (Disaster Recovery) using Terraform? \
State backup \
Multi-region deployment \
Automated re-provisioning \
RBAC access control \
Secrets via Vault \
Policy as Code (Sentinel / OPA) \
 \
