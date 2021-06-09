# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

locals {
  // VCN is /16, each subnet gets a /24
  web_submnet_cidr    = cidrsubnet(var.vpc_cidr, 8, 1)
  private_subnet_cidr = cidrsubnet(var.vpc_cidr, 8, 2)
}

resource "oci_core_virtual_network" "complete_vcn" {
  cidr_block     = var.vpc_cidr
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_tag}_${var.app_description}_${var.app_environment}_vcn"
  dns_label      = var.app_tag
  freeform_tags = {
    app_tag = var.app_tag
  }
}

resource "oci_core_internet_gateway" "complete_ig" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_tag}_${var.app_description}_${var.app_environment}_ig"
  vcn_id         = oci_core_virtual_network.complete_vcn.id
  freeform_tags = {
    app_tag = var.app_tag
  }
}

resource "oci_core_route_table" "route_for_complete" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.complete_vcn.id
  display_name   = "${var.app_tag}_${var.app_description}_${var.app_environment}_rt"

  route_rules {
    #    cidr_block        = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.complete_ig.id
  }
  freeform_tags = {
    app_tag = var.app_tag
  }
}

resource "oci_core_security_list" "web_subnet" {
  compartment_id = var.compartment_ocid
  display_name   = "Public"
  vcn_id         = oci_core_virtual_network.complete_vcn.id

  freeform_tags = {
    app_tag = var.app_tag
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
    tcp_options {
      max = 8888
      min = 8888
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = var.vpc_cidr
  }
}

resource "oci_core_security_list" "private_subnet" {
  compartment_id = var.compartment_ocid
  display_name   = "Private"
  vcn_id         = oci_core_virtual_network.complete_vcn.id

  freeform_tags = {
    app_tag = var.app_tag
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.vpc_cidr
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.vpc_cidr
  }
}

resource "oci_core_subnet" "web_subnetAD1" {
  availability_domain = data.template_file.requested_ad.rendered
  cidr_block          = local.web_submnet_cidr
  display_name        = "web_subnetAD1"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.complete_vcn.id
  route_table_id      = oci_core_route_table.route_for_complete.id
  security_list_ids   = [oci_core_security_list.web_subnet.id]
  dhcp_options_id     = oci_core_virtual_network.complete_vcn.default_dhcp_options_id
  dns_label           = "W1"

  freeform_tags = {
    app_tag = var.app_tag
  }

}

resource "oci_core_subnet" "private_subnetAD1" {
  availability_domain        = data.template_file.requested_ad.rendered
  cidr_block                 = local.private_subnet_cidr
  display_name               = "private_subnetAD1"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.complete_vcn.id
  route_table_id             = oci_core_route_table.route_for_complete.id
  security_list_ids          = [oci_core_security_list.private_subnet.id]
  dhcp_options_id            = oci_core_virtual_network.complete_vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = "true"
  dns_label                  = "P1"

  freeform_tags = {
    app_tag = var.app_tag
  }
}

