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

module "spoke_network" {
  source = "../.."

  resource_names_map      = var.resource_names_map
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  location                = var.location
  class_env               = var.class_env

  use_for_each         = var.use_for_each
  address_space        = var.address_space
  bgp_community        = var.bgp_community
  ddos_protection_plan = var.ddos_protection_plan
  dns_servers          = var.dns_servers
  tracing_tags_enabled = var.tracing_tags_enabled
  tracing_tags_prefix  = var.tracing_tags_prefix
  vnet_tags            = var.vnet_tags
  subnet_map           = var.subnet_map

}
