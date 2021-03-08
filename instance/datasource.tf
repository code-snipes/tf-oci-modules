data "oci_identity_availability_domains" "ad_list" {
  compartment_id = var.instance_tenancy_ocid
}

data "template_file" "ad_names" {
  count    = length(data.oci_identity_availability_domains.ad_list.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad_list.availability_domains[count.index], "name")
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.instance_tenancy_ocid
}

# get the tenancy's home region
data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.instance_vcn_id
}

data "template_file" "oracle_instance_template" {
  #template = file("${path.module}/scripts/instance.template.sh")

  template = var.instance_template_script == "none" ? file("${path.module}/scripts/instance.template.sh") : file(var.instance_template_script)

  count = (var.instance_enabled == true && var.instance_image_id == "Oracle") ? 1 : 0
}

data "template_file" "oracle_cloud_init_file" {
  #template = file("${path.module}/cloudinit/instance.template.yaml")

  template = var.instance_cloud_init_file == "none" ? file("${path.module}/cloudinit/instance.template.yaml") : file(var.instance_cloud_init_file)

  vars = {
    instance_sh_content = base64gzip(data.template_file.oracle_instance_template[0].rendered)
    instance_upgrade    = var.instance_upgrade
    timezone            = var.instance_timezone
  }

  count = (var.instance_enabled == true && var.instance_image_id == "Oracle") ? 1 : 0
}

data "oci_core_images" "oracle_images" {
  compartment_id           = var.instance_compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  shape                    = lookup(var.instance_shape, "shape", "VM.Standard.E2.2")
  sort_by                  = "TIMECREATED"
}

# cloud init for instance
data "template_cloudinit_config" "instance" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "operator.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.oracle_cloud_init_file[0].rendered
  }
  count = var.instance_enabled == true ? 1 : 0
}

# Gets a list of VNIC attachments on the instance instance
data "oci_core_vnic_attachments" "instance_vnics_attachments" {
  availability_domain = element(local.ad_names, (var.instance_availability_domain - 1))
  compartment_id      = var.instance_compartment_id
  depends_on          = [oci_core_instance.instance]
  instance_id         = oci_core_instance.instance[0].id

  count = var.instance_enabled == true ? 1 : 0
}

# Gets the OCID of the first (default) VNIC on the instance instance
data "oci_core_vnic" "instance_vnic" {
  depends_on = [oci_core_instance.instance]
  vnic_id    = lookup(data.oci_core_vnic_attachments.instance_vnics_attachments[0].vnic_attachments[0], "vnic_id")

  count = var.instance_enabled == true ? 1 : 0
}

data "oci_core_instance" "instance" {
  depends_on  = [oci_core_instance.instance]
  instance_id = oci_core_instance.instance[0].id

  count = var.instance_enabled == true ? 1 : 0
}