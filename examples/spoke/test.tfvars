logical_product_service = "spoke"
logical_product_family  = "launch"
class_env               = "sandbox"
instance_env            = 0
instance_resource       = 0
location                = "eastus2"
resource_names_map = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  spoke_vnet = {
    name       = "vnet"
    max_length = 80
  }
  network_security_group = {
    name       = "spokensg"
    max_length = 80
  }
  route_table = {
    name       = "spokert"
    max_length = 80
  }
  spoke_subnet = {
    name       = "spokesubnt"
    max_length = 80
  }
}
use_for_each  = true
address_space = ["172.16.0.0/16"]
subnet_map = {
  "subnet1" = {
    subnet_prefixes                                       = ["172.16.1.0/24"]
    subnet_enforce_private_link_service_network_policies  = false
    subnet_enforce_private_link_endpoint_network_policies = false
    subnet_service_endpoints                              = []
    subnet_delegation                                     = {}
    route_table = { routes = [{
      name                   = "routeToHubFw"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.1.4" // hub firewall private IP
    }] }
    network_security_group = {
      security_rules = [
        {
          name                         = "DenyRdpInbound"
          access                       = "Deny"
          priority                     = 100
          direction                    = "Inbound"
          protocol                     = "Tcp"
          description                  = "Allow RDP inbound traffic from internet"
          source_port_range            = 3389
          destination_port_range       = 3389
          source_address_prefix        = "0.0.0.0/0"       // internet
          destination_address_prefixes = ["172.16.1.0/24"] // spoke-resources subnet prefix
        },
        {
          name                         = "AllowRdpInbound"
          access                       = "Allow"
          priority                     = 101
          direction                    = "Inbound"
          protocol                     = "Tcp"
          description                  = "Allow RDP inbound traffic"
          source_port_range            = 3389
          destination_port_range       = 3389
          source_address_prefix        = "*"               // any source
          destination_address_prefixes = ["172.16.1.0/24"] // spoke-resources subnet prefix
        },
        {
          name                         = "AllowHttpInbound"
          access                       = "Allow"
          priority                     = 102
          direction                    = "Inbound"
          protocol                     = "Tcp"
          description                  = "Allow HTTP inbound traffic"
          source_port_ranges           = [443]
          destination_port_ranges      = [443]
          source_address_prefix        = "*"               // any source
          destination_address_prefixes = ["172.16.1.0/24"] // spoke-resources subnet prefix
        }
      ]
    }
  },
  "subnet2" = {
    subnet_prefixes                                       = ["172.16.2.0/24"]
    subnet_enforce_private_link_service_network_policies  = false
    subnet_enforce_private_link_endpoint_network_policies = false
    subnet_service_endpoints                              = []
    subnet_delegation                                     = {}
    route_table = {
      routes = [{
        name                   = "routeToHubFw"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4" // hub firewall private IP
        }, {
        name                   = "routeToHubFl"
        address_prefix         = "172.16.2.0/24"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.5" // hub firewall private IP
    }] }
    network_security_group = {
      security_rules = [
        {
          name                         = "DenyRdpInbound"
          access                       = "Deny"
          priority                     = 100
          direction                    = "Inbound"
          protocol                     = "Tcp"
          description                  = "Allow RDP inbound traffic from internet"
          source_port_range            = 3389
          destination_port_range       = 3389
          source_address_prefix        = "0.0.0.0/0"       // internet
          destination_address_prefixes = ["172.16.1.0/24"] // spoke-resources subnet prefix
        },
        {
          name                         = "AllowRdpInbound"
          access                       = "Allow"
          priority                     = 101
          direction                    = "Inbound"
          protocol                     = "Tcp"
          description                  = "Allow RDP inbound traffic"
          source_port_range            = 3389
          destination_port_range       = 3389
          source_address_prefix        = "*"               // any source
          destination_address_prefixes = ["172.16.2.0/24"] // spoke-resources subnet prefix
        }
      ]
    }
  }
}
