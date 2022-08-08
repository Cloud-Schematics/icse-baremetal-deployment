##############################################################################
# Create map of total virtual servers for deployment
##############################################################################

locals {
  vsi_list = flatten([
    # For each subnet in the list. Use range to prevent error for values
    # not known until after apply
    for subnet in range(length(var.subnet_zone_list)) :
    [
      # For number of deployments
      for instance in range(var.vsi_per_subnet) :
      {
        name              = "${var.deployment_name}-${(subnet) * (var.vsi_per_subnet) + instance + 1}"
        zone              = var.subnet_zone_list[subnet].zone
        primary_subnet_id = var.subnet_zone_list[subnet].id
      }
    ]
  ])
}

##############################################################################

##############################################################################
# Create Baremetals
##############################################################################

module "baremetal" {
  for_each = {
    for instance in local.vsi_list :
    (instance.name) => instance
  }
  source                            = "github.com/terraform-ibm-modules/icse-baremetal-on-vpc"
  zone                              = each.value.zone
  primary_subnet_id                 = each.value.primary_subnet_id
  name                              = each.value.name
  prefix                            = var.prefix
  tags                              = var.tags
  resource_group_id                 = var.resource_group_id
  vpc_id                            = var.vpc_id
  primary_allowed_vlans             = var.primary_allowed_vlans
  primary_enable_infrastructure_nat = var.primary_enable_infrastructure_nat
  image_id                          = var.image_id
  profile                           = var.profile
  ssh_key_ids                       = var.ssh_key_ids
  boot_volume_name                  = var.boot_volume_name
  user_data                         = var.user_data
  allow_ip_spoofing                 = var.allow_ip_spoofing
  add_floating_ip                   = var.add_floating_ip
  primary_security_group_ids = (
    # If both sg ids and not create sg
    var.primary_security_group_ids == null && var.primary_interface_security_group.create != true
    # null
    ? null
    # if no ids provided and create is true  
    : var.primary_security_group_ids == null
    # list with only created sg id
    ? [module.primary_network_security_group[0].groups[0].id]
    # otherwise combine lists
    : concat(
      var.primary_interface_security_group.create == true ? [module.primary_network_security_group[0].groups[0].id] : [],
      var.primary_security_group_ids
    )
  )
}

##############################################################################