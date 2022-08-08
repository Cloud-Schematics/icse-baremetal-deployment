##############################################################################
# Module Variables
##############################################################################

variable "prefix" {
  description = "The prefix that you would like to prepend to your resources"
  type        = string
}

variable "tags" {
  description = "List of Tags for the resource created"
  type        = list(string)
  default     = null
}

variable "resource_group_id" {
  description = "Resource group ID for the VSI"
  type        = string
  default     = null
}

##############################################################################

##############################################################################
# VPC Variables
##############################################################################

variable "vpc_id" {
  description = "ID of the VPC where VSI will be provisioned"
  type        = string
}

variable "subnet_zone_list" {
  description = "List of subnets where the VSI deployment primary network interfaces will be created. This is intended to be an output from the ICSE Subnet Module or templates using it."
  type = list(
    object({
      name = string
      id   = string
      zone = string
      cidr = string
    })
  )
}

variable "secondary_subnet_zone_list" {
  description = "(Optional) List of secondary subnets to use for VSI. For each secondary subnet in this list, a network interface will be attached to each VSI in the same zone."
  type = list(
    object({
      name = string
      id   = string
      zone = string
      cidr = string
      # optional interface reference shortname used for secondary security group creation
      shortname          = optional(string)
      security_group_ids = optional(list(string))
      allow_ip_spoofing  = optional(bool)
    })
  )
  default = []
}

variable "vsi_per_subnet" {
  description = "Number of identical VSI to provision on each subnet"
  type        = number
  default     = 1
}

##############################################################################

##############################################################################
# Subnet Variables
##############################################################################

variable "primary_allowed_vlans" {
  description = "Comma separated VLANs, Indicates what VLAN IDs (for VLAN type only) can use this physical (PCI type) interface. A given VLAN can only be in the allowed_vlans array for one PCI type adapter per bare metal server."
  type        = list(string)
  default     = null
}

variable "primary_enable_infrastructure_nat" {
  description = " If true, the VPC infrastructure performs any needed NAT operations. If false, the packet is passed unmodified to/from the network interface, allowing the workload to perform any needed NAT operations. [default : true]"
  type        = bool
  default     = true
}

##############################################################################

##############################################################################
# VSI Variables
##############################################################################

variable "deployment_name" {
  description = "Name of the VSI deployment. This will be used to dynamically configure server names."
  type        = string
  default     = "icse"
}

variable "image_id" {
  description = "ID of the server image to use for VSI creation"
  type        = string
  default     = "r010-68ec6c5d-c687-4dd3-8259-6f10d24ecd44"
}

variable "profile" {
  description = "Type of machine profile for VSI. Use the command `ibmcloud is baremetal-profiles` to find available profiles in your region"
  type        = string
  default     = "cx2-metal-96x192"
}

variable "ssh_key_ids" {
  description = "List of SSH Key Ids. At least one SSH key must be provided"
  type        = list(string)

  validation {
    error_message = "To provision VSI at least one VPC SSH Ket must be provided."
    condition     = length(var.ssh_key_ids) > 0
  }
}

variable "boot_volume_name" {
  description = "Boot volume name"
  type        = string
  default     = "eth0"
}

##############################################################################

##############################################################################
# Security Group Variables
##############################################################################

variable "primary_security_group_ids" {
  description = "(Optional) List of security group ids to add to the primary network interface of each virtual server. Using an empty list will assign the default VPC security group."
  type        = list(string)
  default     = null

  validation {
    error_message = "Primary security group IDs should be either `null` or contain at least one security group."
    condition = (
      var.primary_security_group_ids == null
      ? true
      : length(var.primary_security_group_ids) > 0
    )
  }
}

variable "primary_interface_security_group" {
  description = "Object describing a security group to create for the primary interface,"
  type = object({
    create = bool
    rules = list(
      object({
        name      = string
        direction = string
        remote    = string
        tcp = optional(
          object({
            port_max = number
            port_min = number
          })
        )
        udp = optional(
          object({
            port_max = number
            port_min = number
          })
        )
        icmp = optional(
          object({
            type = number
            code = number
          })
        )
      })
    )
  })
  default = {
    create = false
    rules  = []
  }
}

##############################################################################


##############################################################################
# Common Optional Variables
##############################################################################

variable "user_data" {
  description = "(Optional) Data to transfer to instance"
  type        = string
  default     = null
}

variable "allow_ip_spoofing" {
  description = "Allow IP spoofing on primary network interface"
  type        = bool
  default     = false
}

variable "add_floating_ip" {
  description = "Add a floating IP to the primary network interface."
  type        = bool
  default     = false
}

##############################################################################