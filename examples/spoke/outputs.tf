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

output "resource_group_id" {
  description = "resource group id"
  value       = module.spoke_network.resource_group_id
}

output "resource_group_name" {
  description = "resource group name"
  value       = module.spoke_network.resource_group_name
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = module.spoke_network.vnet_address_space
}

output "vnet_guid" {
  description = "The GUID of the newly created vNet"
  value       = module.spoke_network.vnet_guid
}

output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = module.spoke_network.vnet_id
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = module.spoke_network.vnet_location
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = module.spoke_network.vnet_name
}

output "vnet_subnets" {
  description = "The ids of subnets created inside the newly created vNet"
  value       = module.spoke_network.vnet_subnets
}

output "vnet_subnets_name_id" {
  description = "Can be queried subnet-id by subnet name by using lookup(module.vnet.vnet_subnets_name_id, subnet1)"
  value       = module.spoke_network.vnet_subnets_name_id
}

output "network_security_group_ids" {
  description = "value of the network security group id."
  value       = module.spoke_network.network_security_group_ids
}

output "route_table_ids" {
  value       = module.spoke_network.route_table_ids
  description = "The Route Table ID."
}

output "route_table_names" {
  value       = module.spoke_network.route_table_names
  description = "The Route Table Name."
}

output "route_table_rules" {
  value       = module.spoke_network.route_table_rules
  description = "The Route ids."
}
