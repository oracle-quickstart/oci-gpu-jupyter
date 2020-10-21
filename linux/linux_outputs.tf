# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "ids" {
  value = [oci_core_instance.linux_instance.*.id]
}

output "public_address" {
  value = [oci_core_instance.linux_instance.*.public_ip]
}

output "private_address" {
  value = [oci_core_instance.linux_instance.*.private_ip]
}
