# Introduction 
Creates a Public IP Address with the following naming convention: pip-(application_name)-(subscription_type)-(instance_number).

Exp: pip-myapp-dev-001

# Parameters
| Variable      | Description |
| :---        |    :----   |
| application_name      | Application or Service name used to build the Public IP name       |
| subscription_type   | Subscription type used to build the Public IP name        |
| instance_number   | Instance number used to build the Public IP name        |
| location   | The Azure Region where the Public IP should exist.        |
| allocation_method   | (Optional) Defines the allocation method for this IP address. Possible values are Static or Dynamic.        |
| sku   | (Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic.        |
| zones  | (Optional) A collection containing the availability zone to allocate the Public IP in.        |
| domain_name_label   | (Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.        |
| edge_zone   | (Optional) Specifies the Edge Zone within the Azure Region where this Public IP should exist. Changing this forces a new Public IP to be created.        |
| idle_timeout_in_minues   |  (Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes.        |
|  id_tag   | (Optional) A mapping of IP tags to assign to the public IP.   | 
|  id_version   |  (Optional) The IP Version to use, IPv6 or IPv4. | 
|  public_ip_prefix_id   |  (Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. | 
|  reverse_fqdn   |   (Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. | 
| sku_tier   | (Optional) The SKU Tier that should be used for the Public IP. Possible values are Regional and Global. Defaults to Regional.        |
| public_ip_name_override   | (Optional) Explicitly override the module generated name.         |
| tags   | (Optional) A mapping of tags to assign to the resource.        |

# Outputs
| Output      | Description |
| :---        |    :----   |
| id   | The ID of this Public IP. |
| ip_ipaddress   | The IP address value that was allocated. |
| fqdn   |  Fully qualified domain name of the A DNS record associated with the public IP. domain_name_label must be specified to get the fqdn. This is the concatenation of the domain_name_label and the regionalized DNS zone. |