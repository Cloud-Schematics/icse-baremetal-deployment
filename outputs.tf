##############################################################################
# VSI Outputs
##############################################################################

output "virtual_servers" {
  description = "List of VSI IDs, Names, Primary IPV4 addresses, floating IPs, and secondary floating IPs"
  value = [
    for instance in module.vsi :
    {
      id                   = instance.id
      name                 = instance.name
      primary_ipv4_address = instance.primary_ipv4_address
      floating_ip          = instance.floating_ip
    }
  ]
}

##############################################################################