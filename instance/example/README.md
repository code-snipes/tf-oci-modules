```terraform
locals {

  label_prefix            = "demo"
  label_postfix           = "poc"
  ssh_public_key          = ""
  ssh_public_key_path     = "~/.ssh/your_rsa.pub"
  timezone                = "UTC"
  server_prefix           = "app"
  server_enabled          = true
  server_instance_count   = 1
  server_custom_script    = "./template.sh"
  server_cloud_init_file  = "./template.yaml"

}

module "webserver" {
  source = "git@github.com:code-snipes/tf-oci-modules.git//instance"
  count                        = local.server_instance_count
  instance_enabled             = local.server_enabled
  instance_tenancy_ocid        = local.tenancy_ocid
  instance_label_prefix        = "${local.label_prefix}-${local.server_prefix}"
  instance_label_postfix       = "${count.index + 1}-${local.label_postfix}"
  instance_compartment_id      = "YourCompartment_OCID"
  instance_availability_domain = 1
  instance_vcn_id              = "YourVCN_OCID"
  instance_subnet_id           = "YourSUBNET_OCID"
  instance_nat_route_id        = ""
  instance_nsg_ids             = []
  instance_image_id            = "Oracle"
  instance_instance_principal  = true
  instance_shape = {
    shape  = "VM.Standard.E3.Flex",
    ocpus  = 2,
    memory = 12,
    boot_volume_size = 50
  }
  instance_upgrade             = true
  instance_ssh_public_key      = local.ssh_public_key
  instance_ssh_public_key_path = local.ssh_public_key_path
  instance_timezone            = local.timezone
  instance_template_script     = local.server_custom_script
  instance_cloud_init_file     = local.server_cloud_init_file
}

output "instance_private_ip" {
  value = join(",", data.oci_core_vnic.instance_vnic.*.private_ip_address)
}
output "instance_display_name" {
  value = join(",", data.oci_core_instance.instance.*.display_name)
}
```