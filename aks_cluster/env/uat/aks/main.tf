data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "existing" { name = var.resource_group_name }
data "azurerm_user_assigned_identity" "aks" {
  name = var.aks_identity_name
  resource_group_name = var.aks_identity_resource_group_name
}
module "network" {
  source = "../../../modules/network"
  vnet_resource_group_name = var.vnet_resource_group_name
  virtual_network_name = var.virtual_network_name
  aks_subnet_name = var.aks_subnet_name
}
resource "azurerm_role_assignment" "aks_network" {
  count = var.create_aks_network_role_assignment ? 1 : 0
  scope = module.network.vnet_id
  role_definition_name = "Network Contributor"
  principal_id = data.azurerm_user_assigned_identity.aks.principal_id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "aks_route_table" {
  count = var.create_aks_route_table_role_assignment && var.outbound_type == "userDefinedRouting" ? 1 : 0
  scope = module.network.route_table_id
  role_definition_name = "Network Contributor"
  principal_id = data.azurerm_user_assigned_identity.aks.principal_id
  skip_service_principal_aad_check = true
  lifecycle { precondition {
    condition = module.network.route_table_id != null && module.network.route_table_id != ""
    error_message = "An existing route table must be associated with the subnet."
  } }
}
module "aks" {
  source = "../../../modules/aks"
  cluster_name = var.aks_cluster_name
  dns_prefix = var.aks_dns_prefix
  resource_group_name = data.azurerm_resource_group.existing.name
  location = module.network.location
  subnet_id = module.network.subnet_id
  control_plane_identity_id = data.azurerm_user_assigned_identity.aks.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  node_count = var.node_count
  node_vm_size = var.node_vm_size
  availability_zones = var.availability_zones
  kubernetes_version = var.kubernetes_version
  vnet_prefixes = module.network.vnet_prefixes
  connected_network_cidrs = var.connected_network_cidrs
  pod_cidr = var.pod_cidr
  service_cidr = var.service_cidr
  dns_service_ip = var.dns_service_ip
  outbound_type = var.outbound_type
  udr_egress_ready = var.udr_egress_ready
  tags = merge(var.tags, { Environment = upper("uat"), ManagedBy = "Terraform", Workload = "AKS-Admin" })
  depends_on = [azurerm_role_assignment.aks_network, azurerm_role_assignment.aks_route_table]
}
resource "azurerm_role_assignment" "cluster_user" {
  for_each = toset(var.admin_group_object_ids)
  scope = module.aks.cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id = each.value
  principal_type = "Group"
}
resource "azurerm_role_assignment" "kubernetes_admin" {
  for_each = toset(var.admin_group_object_ids)
  scope = module.aks.cluster_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id = each.value
  principal_type = "Group"
}
