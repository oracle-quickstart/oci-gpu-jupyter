# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Location of file system to mount. If left empty,
# no mount will be attempted and no disk will be allocated.
# NOTE: If a volume is requested for the VM, a private key must be
# provided via an authentication agent : ssh-agent (Unix), pageant (Windows)
variable "linux_mount_directory" {
  type    = list(string)
  default = []
}

variable "linux_size_in_gbs" {
  type    = list(string)
  default = []
}

# This will be used in the DNS & display name for the instance.
# Note that names will be truncated to meet DNS restrictions. 
variable "linux_description" {
  default = "linux"
}

variable "linux_instance_shape" {
}

variable "linux_skip_source_dest_check" {
  default = false
}

variable "linux_login" {
  default = "opc"
}

variable "linux_image_ocid" {}

variable "linux_assign_public_ip" {
  default = "false"
}

variable "bastion_public_ip" {
  default = ""
}

variable "linux_bootstrap_file" {}

variable "linux_availability_domain" {}

variable "linux_count" {}

variable "linux_ssh_public_key" {}

variable "linux_ssh_private_key" {}

variable "linux_backup_policy" {}

variable "tenancy_ocid" {
  description = "tenancy id"
  type        = string
}

variable "compartment_ocid" {}

variable "app_tag" {}

variable "environment" {}

variable "vcn_cidr" {}

variable "vcn_id" {}

variable "linux_subnet_id" {}

variable "format_disk" {
  default = "true"
}

variable "mp_listing_id" {
  default = ""
}

variable "mp_listing_resource_id" {
  default = ""
}

variable "mp_listing_resource_version" {
  default = ""
}

variable "use_marketplace_image" {
  default = true
}
