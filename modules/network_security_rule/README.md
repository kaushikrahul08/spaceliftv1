# Introduction 
Creates a network_security_rule. 

# Parameters

The module's input is a map of parameters like the example below.
```
nsgrules = {

  rule1 = {
    name                         = "ssh"
    description                  = null
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_port_ranges           = null
    destination_port_range       = "22"
    destination_port_ranges      = null
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = null
    destination_address_prefix   = "*"
    destination_address_prefixes = null
  }

  rule2 = {
    name                         = "rdp"
    description                  = null
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_port_ranges           = null
    destination_port_range       = "3389"
    destination_port_ranges      = null
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = null
    destination_address_prefix   = "*"
    destination_address_prefixes = null
  }
  .
  .
  .
}
```
| Variable      | Description |
| :---        |    :----   |
| name      | The name of the security rule. This needs to be unique across all Rules in the Network Security Group.       |
| description   | (Optional) A description for this rule. Restricted to 140 characters. Set to null to omit.        |
| priority           | Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.   |
| direction   | The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound.        |
| access   | Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny.        |
| protocol   | Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).        |
| source_port_range   | (Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. Set to null to omit. This is required if source_port_ranges is not specified.        |
| source_port_ranges   | (Optional) List of source ports or port ranges. Set to null to omit. This is required if source_port_range is not specified.        |
| destination_port_range   | (Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. Set to null to omit. This is required if destination_port_ranges is not specified.        |
| destination_port_ranges   | (Optional) List of destination ports or port ranges. Set to null to omit. This is required if destination_port_range is not specified.        |
| source_address_prefix   | (Optional) CIDR or source IP range or * to match any IP. Tags such as ‘VirtualNetwork’, ‘AzureLoadBalancer’ and ‘Internet’ can also be used. Set to null to omit. This is required if source_address_prefixes is not specified.        |
| source_address_prefixes   | (Optional) List of source address prefixes. Tags may not be used. Set to null to omit. This is required if source_address_prefix is not specified.        |
| destination_address_prefix   | (Optional) CIDR or destination IP range or * to match any IP. Tags such as ‘VirtualNetwork’, ‘AzureLoadBalancer’ and ‘Internet’ can also be used. Besides, it also supports all available Service Tags like ‘Sql.WestEurope‘, ‘Storage.EastUS‘, etc. Set to null to omit. This is required if destination_address_prefixes is not specified.        |
| destination_address_prefixes   | (Optional) List of destination address prefixes. Tags may not be used. Set to null to omit. This is required if destination_address_prefix is not specified.        |
