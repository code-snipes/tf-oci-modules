# ---------------------------------------------------------------------------------------------------------------------
# MISC
# ---------------------------------------------------------------------------------------------------------------------
variable "instance_tenancy_ocid" {
  type = string
}
variable "instance_label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

variable "instance_label_postfix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

# ---------------------------------------------------------------------------------------------------------------------
# GENERATE INSTANCE: instance
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_enabled" {
  description = "whether to create the instance"
  default     = false
  type        = bool
}

variable "instance_compartment_id" {
  description = "The id of the compartmnet to use when creating the instance resources."
  type        = string
}

variable "instance_availability_domain" {
  description = "the AD to place the instance host"
  default     = 1
  type        = number
}

variable "instance_vcn_id" {
  description = "The id of the VCN to use when creating the instance resources."
  type        = string
}

variable "instance_subnet_id" {
  description = "The id of the subnet to use when creating the instance resources."
  type        = string
}

variable "instance_nat_route_id" {
  description = "the id of the route table to the nat gateway."
  type        = string
}
variable "instance_nsg_ids" {
  description = "Optional list of network security groups that the instance will be part of"
  type        = list(string)
  default     = []
}

variable "instance_image_id" {
  description = "Provide a custom image id for the instance host or leave as Autonomous."
  default     = "Oracle"
  type        = string
}

variable "instance_instance_principal" {
  description = "whether to enable instance_principal on the instance"
  default     = false
  type        = bool
}

variable "instance_shape" {
  description = "The shape of the instance instance."
  default = {
    shape = "VM.Standard.E3.Flex", ocpus = 1, memory = 4, boot_volume_size = 50
  }
  type = map(any)
}

variable "instance_upgrade" {
  description = "Whether to upgrade the instance host packages after provisioning. It's useful to set this to false during development/testing so the instance is provisioned faster."
  default     = false
  type        = bool
}

variable "instance_ssh_public_key" {
  description = "the content of the ssh public key used to access the instance. set this or the instance_ssh_public_key_path"
  default     = ""
  type        = string
}

variable "instance_ssh_public_key_path" {
  description = "path to the ssh public key used to access the instance. set this or the instance_ssh_public_key"
  default     = ""
  type        = string
}

variable "instance_timezone" {
  description = "The preferred timezone for the instance host."
  default     = "Australia/Sydney"
  type        = string
}


variable "instance_template_script" {
  description = "Customization Script for the Instance"
  default     = "none"
  type        = string
}

variable "instance_cloud_init_file" {
  description = "Customization CloudInit Script for the Instance"
  default     = "none"
  type        = string
}

variable "instance_operating_system" {
  description = "Customize Operationg System for the Instance"
  default     = "Oracle Linux"
  type        = string
}

variable "instance_operating_system_version " {
  description = "Customize Operationg System version for the Instance"
  default     = "7.9"
  type        = string
}
