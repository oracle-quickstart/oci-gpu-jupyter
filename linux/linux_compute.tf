# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_core_instance" "linux_instance" {
  availability_domain = var.linux_availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.app_tag}_${var.linux_description}_${var.environment}_${count.index}"
  shape               = var.linux_instance_shape
  count               = var.linux_count

  freeform_tags = {
    app_tag = var.app_tag
  }

  source_details {
    source_id   = var.linux_image_ocid
    source_type = "image"
  }

  create_vnic_details {
    subnet_id              = var.linux_subnet_id
    skip_source_dest_check = var.linux_skip_source_dest_check
    assign_public_ip       = var.linux_assign_public_ip
    hostname_label         = lower(format("%.15s", format("%s%s%d", var.app_tag, var.linux_description, count.index)))
  }

  metadata = {
    ssh_authorized_keys = var.linux_ssh_public_key
    user_data           = base64encode(file(var.linux_bootstrap_file))
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_volume" "linux_blocks" {
  availability_domain = var.linux_availability_domain
  compartment_id      = var.compartment_ocid
  count               = var.linux_count * (length(var.linux_mount_directory))
  display_name        = var.linux_mount_directory[count.index % length(var.linux_mount_directory)]
  size_in_gbs         = var.linux_size_in_gbs[count.index % length(var.linux_mount_directory)]

  freeform_tags = {
    app_tag = var.app_tag
  }
}

resource "oci_core_volume_attachment" "script_blocks_attach" {
  attachment_type = "iscsi"
  count           = var.format_disk != true ? length(var.linux_mount_directory) > 0 ? var.linux_count * length(var.linux_mount_directory) : 0 : 0
  instance_id     = element(oci_core_instance.linux_instance.*.id, count.index)
  volume_id       = element(oci_core_volume.linux_blocks.*.id, count.index)

  provisioner "remote-exec" {
    connection {
      timeout      = "20m"
      host         = length(var.bastion_public_ip) > 7 ? element(oci_core_instance.linux_instance.*.private_ip, count.index) : element(oci_core_instance.linux_instance.*.public_ip, count.index)
      bastion_host = var.bastion_public_ip
      user         = var.linux_login
      agent        = false
      private_key  = file(var.linux_ssh_private_key)
    }

    inline = [
      # Logging for troubleshooting.
      "set -x",

      # Command provided in OCI console to register ISCSI device.
      "sudo -s bash -c 'iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}'",

      # Command provided in OCI console for registration to survive reboot.
      "sudo -s bash -c 'iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic '",

      # Command provided in OCI console to log into iscsi device.
      "sudo -s bash -c 'iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l '",
    ]
  }
}

resource "oci_core_volume_attachment" "linux_blocks_attach" {
  attachment_type = "iscsi"
  count           = var.format_disk == true ? length(var.linux_mount_directory) > 0 ? var.linux_count * length(var.linux_mount_directory) : 0 : 0
  instance_id     = element(oci_core_instance.linux_instance.*.id, count.index)
  volume_id       = element(oci_core_volume.linux_blocks.*.id, count.index)
  use_chap        = true

  provisioner "remote-exec" {
    connection {
      timeout      = "20m"
      host         = length(var.bastion_public_ip) > 7 ? element(oci_core_instance.linux_instance.*.private_ip, count.index) : element(oci_core_instance.linux_instance.*.public_ip, count.index)
      bastion_host = var.bastion_public_ip
      user         = var.linux_login
      agent        = false
      private_key  = file(var.linux_ssh_private_key)
    }

    inline = [
      # Logging for troubleshooting.
      "set -x",

      "sudo -s bash -c 'lsscsi -t' ",

      # Command provided in OCI console to register ISCSI device.
      "sudo -s bash -c 'iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}'",

      # Command provided in OCI console for registration to survive reboot.
      "sudo -s bash -c 'iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic '",

      # Authenticate the iSCSI connection by providing the volume's CHAP credentials.
      "sudo -s bash -c 'iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -o update -n node.session.auth.authmethod -v CHAP' ",

      # Provide the volume's CHAP user name.
      "sudo -s bash -c 'iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -o update -n node.session.auth.username -v ${self.chap_username}' ",

      # Provide the volume's CHAP password.
      "sudo -s bash -c 'iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -o update -n node.session.auth.password -v ${self.chap_secret}' ",

      # Command provided in OCI console to log into iscsi device.
      "sudo -s bash -c 'iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l '",

      # troubleshooting command.
      "sudo -s bash -c 'lsscsi -t' ",

      # troubleshooting command
      "lsscsi -t | grep disk | grep ${self.iqn} | awk '{print $1,$2,$3,$4,$5}'",

      # Find the specific OS level device that is associated with the iscsi volume.
      "device=$(lsscsi -t | grep disk | grep ${self.iqn} | awk '{print $4}')",

      # Create a file system on the device. In this case, we use the ext4 filesystem.
      "sudo -s bash -c \"mkfs.ext4 -F $device\" ",

      # Create a directory in the OS to mount the new filesystem.
      "sudo -s bash -c 'mkdir -p ${var.linux_mount_directory[count.index % length(var.linux_mount_directory)]}'",

      # Mount the filesystem so that it's available.
      "sudo -s bash -c \"mount -t ext4 $device ${var.linux_mount_directory[count.index % length(var.linux_mount_directory)]} \" ",

      # Find the UUID of the iscsi volume.
      "uuid=$(sudo blkid | grep $device | awk '{print $2}')",

      # Ensure the filesystem is loaded on a reboot of the instance.
      "echo \"$uuid ${var.linux_mount_directory[count.index % length(var.linux_mount_directory)]} ext4 defaults,noatime,_netdev,nofail    0   2\" | sudo tee --append /etc/fstab > /dev/null",
    ]
  }
}

# Setup backup policies for disks
resource "oci_core_volume_backup_policy_assignment" "policy" {
  count     = var.linux_count * (length(var.linux_mount_directory))
  asset_id  = element(oci_core_volume.linux_blocks.*.id, count.index)
  policy_id = data.oci_core_volume_backup_policies.test_boot_volume_backup_policies.volume_backup_policies.0.id
}

# See policy definition:
# https://docs.cloud.oracle.com/en-us/iaas/Content/Block/Tasks/schedulingvolumebackups.htm
data "oci_core_volume_backup_policies" "test_boot_volume_backup_policies" {
  filter {
    name   = "display_name"
    values = [var.linux_backup_policy]
  }
}
