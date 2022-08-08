# ICSE Baremetal Deployment Module

Deploy baremetals using the same template across any number of subnets in a single VPC.

---

## Module Variables

Name                              | Type                                                                                                                                                                                                                                                                                                  | Description                                                                                                                                                                                                                  | Sensitive | Default
--------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | -----------------------------------------
prefix                            | string                                                                                                                                                                                                                                                                                                | The prefix that you would like to prepend to your resources                                                                                                                                                                  |           | 
tags                              | list(string)                                                                                                                                                                                                                                                                                          | List of Tags for the resource created                                                                                                                                                                                        |           | null
resource_group_id                 | string                                                                                                                                                                                                                                                                                                | Resource group ID for the VSI                                                                                                                                                                                                |           | null
vpc_id                            | string                                                                                                                                                                                                                                                                                                | ID of the VPC where VSI will be provisioned                                                                                                                                                                                  |           | 
subnet_zone_list                  | list( object({ name = string id = string zone = string cidr = string }) )                                                                                                                                                                                                                             | List of subnets where the VSI deployment primary network interfaces will be created. This is intended to be an output from the ICSE Subnet Module or templates using it.                                                     |           | 
secondary_subnet_zone_list        | list( object({ name = string id = string zone = string cidr = string shortname = optional(string) security_group_ids = optional(list(string)) allow_ip_spoofing = optional(bool) }) )                                                                                                                 | (Optional) List of secondary subnets to use for VSI. For each secondary subnet in this list, a network interface will be attached to each VSI in the same zone.                                                              |           | []
vsi_per_subnet                    | number                                                                                                                                                                                                                                                                                                | Number of identical VSI to provision on each subnet                                                                                                                                                                          |           | 1
primary_allowed_vlans             | list(string)                                                                                                                                                                                                                                                                                          | Comma separated VLANs, Indicates what VLAN IDs (for VLAN type only) can use this physical (PCI type) interface. A given VLAN can only be in the allowed_vlans array for one PCI type adapter per bare metal server.          |           | null
primary_enable_infrastructure_nat | bool                                                                                                                                                                                                                                                                                                  | " If true, the VPC infrastructure performs any needed NAT operations. If false, the packet is passed unmodified to/from the network interface, allowing the workload to perform any needed NAT operations. [default : true]" |           | true
deployment_name                   | string                                                                                                                                                                                                                                                                                                | Name of the VSI deployment. This will be used to dynamically configure server names.                                                                                                                                         |           | icse
image_id                          | string                                                                                                                                                                                                                                                                                                | ID of the server image to use for VSI creation                                                                                                                                                                               |           | r010-68ec6c5d-c687-4dd3-8259-6f10d24ecd44
profile                           | string                                                                                                                                                                                                                                                                                                | Type of machine profile for VSI. Use the command `ibmcloud is baremetal-profiles` to find available profiles in your region                                                                                                  |           | cx2-metal-96x192
ssh_key_ids                       | list(string)                                                                                                                                                                                                                                                                                          | List of SSH Key Ids. At least one SSH key must be provided                                                                                                                                                                   |           | 
boot_volume_name                  | string                                                                                                                                                                                                                                                                                                | Boot volume name                                                                                                                                                                                                             |           | eth0
primary_security_group_ids        | list(string)                                                                                                                                                                                                                                                                                          | (Optional) List of security group ids to add to the primary network interface of each virtual server. Using an empty list will assign the default VPC security group.                                                        |           | null
primary_interface_security_group  | object({ create = bool rules = list( object({ name = string direction = string remote = string tcp = optional( object({ port_max = number port_min = number }) ) udp = optional( object({ port_max = number port_min = number }) ) icmp = optional( object({ type = number code = number }) ) }) ) }) | Object describing a security group to create for the primary interface,                                                                                                                                                      |           | { create = false rules = []
user_data                         | string                                                                                                                                                                                                                                                                                                | (Optional) Data to transfer to instance                                                                                                                                                                                      |           | null
allow_ip_spoofing                 | bool                                                                                                                                                                                                                                                                                                  | Allow IP spoofing on primary network interface                                                                                                                                                                               |           | false
add_floating_ip                   | bool                                                                                                                                                                                                                                                                                                  | Add a floating IP to the primary network interface.                                                                                                                                                                          |           | false

---

## Module Outputs

Name                  | Description
--------------------- | ----------------------------------------------------------------------------------------
virtual_servers       | List of VSI IDs, Names, Primary IPV4 addresses, floating IPs, and secondary floating IPs