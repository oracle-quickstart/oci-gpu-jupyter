# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  region               = var.region
  private_key_password = var.private_key_password
}

module "single_instance_multiple_disks" {
  source                      = "./linux"
  tenancy_ocid                = var.tenancy_ocid
  compartment_ocid            = var.compartment_ocid
  app_tag                     = var.app_tag
  environment                 = var.app_environment
  vcn_cidr                    = ""
  vcn_id                      = ""
  format_disk                 = true
  mp_listing_id               = var.mp_listing_id
  mp_listing_resource_id      = var.mp_listing_resource_id
  mp_listing_resource_version = var.mp_listing_resource_version
  linux_bootstrap_file        = "./scripts/empty_script.sh"
  linux_image_ocid            = var.mp_listing_resource_id
  linux_ssh_public_key        = file(var.ssh_public_key)
  linux_ssh_private_key       = var.ssh_private_key
  linux_size_in_gbs           = [var.volume_size_in_gbs]
  linux_mount_directory       = ["/test/data"]
  linux_assign_public_ip      = true
  linux_description           = var.app_description
  linux_instance_shape        = var.instance_shape
  linux_count                 = var.number_instances
  linux_availability_domain   = data.template_file.requested_ad.rendered
  linux_subnet_id             = oci_core_subnet.web_subnetAD1.id
  linux_backup_policy         = var.backup_policy
}

resource "local_file" "jupyter" {
  content = templatefile("${path.module}/scripts/${var.script_to_run}.tpl", {
    jupyter_password = var.jupyter_password
    github_repo      = var.github_repo
  })
  filename = "${path.module}/scripts/${var.script_to_run}.gen"
}

resource "null_resource" "configure_jupyterhub" {
  depends_on = [module.single_instance_multiple_disks]
  connection {
    timeout     = "5m"
    host        = module.single_instance_multiple_disks.public_address[0][0]
    user        = "opc"
    agent       = false
    private_key = file(var.ssh_private_key)

  }

  provisioner "file" {
    source      = "${path.module}/scripts/${var.script_to_run}.gen"
    destination = "/tmp/${data.external.get_filename.result.r_filename}"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/${var.script_to_run}.gen"
    destination = "/home/opc/${var.script_to_run}.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${data.external.get_filename.result.r_filename}",
      "/tmp/${data.external.get_filename.result.r_filename}  ",
      "rm /tmp/${data.external.get_filename.result.r_filename}",
    ]
  }
}

output "ssh_tunnel_for_notebook" {
  value       = "ssh -i ${var.ssh_private_key} -L 8081:localhost:8080 opc@${module.single_instance_multiple_disks.public_address[0][0]}"
  description = "Command to create ssh tunnel for Jupyter Notebook. Browse to http://localhost:8081 to see notebooks"
}

output "all_nodes_created" {
  value       = module.single_instance_multiple_disks.public_address[0]
  description = "Show all public IP addresses created."
}
output "ssh_to_notebook_vm" {
  value       = "ssh -i ${var.ssh_private_key} opc@${module.single_instance_multiple_disks.public_address[0][0]}"
  description = "Command to ssh into Jupyter Notebook VM."
}

output "Next_Steps" {
  value       = "Create an ssh tunnel to the Jupyter VM and then open your browser to http://localhost:8081 "
  description = "Next steps."
}

data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

data "template_file" "ad_names" {
  count = length(
    data.oci_identity_availability_domains.ad.availability_domains,
  )
  template = data.oci_identity_availability_domains.ad.availability_domains[count.index]["name"]
}

data "template_file" "requested_ad" {
  template = data.oci_identity_availability_domains.ad.availability_domains[var.AD - 1]["name"]
}


data "external" "get_filename" {
  program = ["bash", "./scripts/generate_random_filename.sh"]
}

