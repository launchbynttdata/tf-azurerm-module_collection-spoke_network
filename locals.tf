locals {

  //Create standard names for resources and put them in a type expected by the modules
  resource_group_name  = module.resource_names["resource_group"].standard
  virtual_network_name = module.resource_names["spoke_vnet"].standard
  subnet_names = var.subnet_map == null ? {} : {
    for key, value in var.subnet_map : key => "${module.resource_names["spoke_subnet"].standard}_${key}"
  }
  subnet_names_list = keys(local.subnet_names)

  //Modify the subnet map variable to include standard name for each of the resource to be created with subnet.
  //Key for this resources is the non-standard subnet name and value is subnet attributes.
  modified_subnet_map = var.subnet_map == null ? {} : {
    for key, value in var.subnet_map : key => merge(value, {
      name = local.subnet_names[key],
      network_security_group = merge(value.network_security_group, {
        network_security_group_name = "${module.resource_names["network_security_group"].standard}_${key}"
      }),
      route_table = merge(value.route_table, {
        route_table_name = "${module.resource_names["route_table"].standard}_${key}"
      })
    })
  }

  //Create a map of network security groups
  //Key is the non standard subnet name and value is the network security group attributes
  network_security_groups = {
    for key, value in local.modified_subnet_map : key => value.network_security_group
  }

  //Create a map of route tables
  //Key is the non standard subnet name and value is the route table attributes
  route_tables = {
    for key, value in local.modified_subnet_map : key => value.route_table
  }

  //Create a map of routes
  //Key is the non standard route name and value is the route attributes
  routes_map = {
    for key, value in local.modified_subnet_map : value.route_table.route_table_name => {
      for route in value.route_table.routes : route.name => {
        name                   = route.name
        resource_group_name    = local.resource_group_name
        route_table_name       = value.route_table.route_table_name
        address_prefix         = route.address_prefix
        next_hop_type          = route.next_hop_type
        next_hop_in_ip_address = route.next_hop_in_ip_address != null ? route.next_hop_in_ip_address : null
      }
    }
  }

  //Create individual maps for each of the subnet attributes to be passed to the module
  subnet_delegation = {
    for key, value in local.modified_subnet_map : key => value.subnet_delegation
  }

  subnet_enforce_private_link_endpoint_network_policies = {
    for key, value in local.modified_subnet_map : key => value.subnet_enforce_private_link_endpoint_network_policies
  }

  subnet_enforce_private_link_service_network_policies = {
    for key, value in local.modified_subnet_map : key => value.subnet_enforce_private_link_service_network_policies
  }

  subnet_service_endpoints = {
    for key, value in local.modified_subnet_map : key => value.subnet_service_endpoints
  }

  subnet_prefixes = flatten([
    for key, value in local.modified_subnet_map : value.subnet_prefixes
  ])
}
