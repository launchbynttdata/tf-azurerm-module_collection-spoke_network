// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source = "git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git?ref=1.0.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.location))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}

module "resource_group" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-resource_group.git?ref=1.0.0"

  name     = local.resource_group_name
  location = var.location
  tags = {
    resource_name = local.resource_group_name
  }
}

module "network" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-virtual_network.git?ref=1.0.0"

  resource_group_name                                   = module.resource_group.name
  use_for_each                                          = var.use_for_each
  vnet_location                                         = var.location
  address_space                                         = var.address_space
  bgp_community                                         = var.bgp_community
  ddos_protection_plan                                  = var.ddos_protection_plan
  dns_servers                                           = var.dns_servers
  subnet_delegation                                     = local.subnet_delegation
  subnet_enforce_private_link_endpoint_network_policies = local.subnet_enforce_private_link_endpoint_network_policies
  subnet_enforce_private_link_service_network_policies  = local.subnet_enforce_private_link_service_network_policies
  subnet_names                                          = local.subnet_names_list
  subnet_prefixes                                       = local.subnet_prefixes
  subnet_service_endpoints                              = local.subnet_service_endpoints
  tracing_tags_enabled                                  = var.tracing_tags_enabled
  tracing_tags_prefix                                   = var.tracing_tags_prefix
  vnet_name                                             = local.virtual_network_name
  tags                                                  = var.vnet_tags


  depends_on = [module.resource_group]
}

module "network_security_group" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-network_security_group.git?ref=1.0.0"

  for_each = local.network_security_groups

  name                = each.value.network_security_group_name
  location            = var.location
  resource_group_name = module.resource_group.name
  security_rules      = each.value.security_rules
  tags = {
    resource_name = each.value.network_security_group_name
  }

  depends_on = [module.resource_group]
}

module "network_security_group_subnet_asscoation" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-nsg_subnet_association.git?ref=1.0.0"

  for_each = local.subnet_names

  subnet_id                 = lookup(module.network.vnet_subnets_name_id, each.key)
  network_security_group_id = module.network_security_group[each.key].network_security_group_id

  depends_on = [module.network]
}

module "route_table" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-route_table.git?ref=1.0.0"

  for_each = local.route_tables

  name                = each.value.route_table_name
  resource_group_name = module.resource_group.name
  location            = var.location
  tags = {
    resource_name = each.value.route_table_name
  }

  depends_on = [module.resource_group]
}

module "route_table_rules" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-route.git?ref=1.0.0"

  for_each = local.routes_map

  routes = each.value

  depends_on = [module.route_table]
}

module "route_table_subnet_asscoation" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-routetable_subnet_association.git?ref=1.0.0"

  for_each = local.subnet_names

  subnet_id      = lookup(module.network.vnet_subnets_name_id, each.key)
  route_table_id = module.route_table[each.key].id


  depends_on = [module.network]
}
