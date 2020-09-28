# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "region" {
  default = "us-ashburn-1"
}

variable "private_key_password" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}

variable "number_instances" {
  default = 1
}

# "BM.GPU2.2"
# "VM.GPU2.1"
# "BM.GPU3.8"
# "VM.GPU3.1"
# "VM.GPU3.2"
# "VM.GPU3.4"
# VM.GPU2.1  VM.GPU2.1
variable "instance_shape" {
  default = "VM.GPU2.1"
}

variable "ssh_public_key" {
  default = ""
}

variable "ssh_private_key" {
  default = ""
}

# Choose an Availability Domain
variable "AD" {
  default = "1"
}

# Set default size of volumes
variable "volume_size_in_gbs" {
  default = "1024"
}

variable "InstanceImageOCID" {
  type = map(string)

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.4-2018.02.21-1"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaaupbfz5f5hdvejulmalhyb6goieolullgkpumorbvxlwkaowglslq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaajlw3xfie2t5t52uegyhiq2npx7bqyu4uvi2zyu3w3mqayc2bxmaa"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7d3fsb6272srnftyi4dphdgfjf6gurxqhmv6ileds7ba3m2gltxq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaa6h6gj6v4n56mqrbgnosskq63blyv2752g36zerymy63cfkojiiq"
  }
}

variable "script_to_run" {
  default = "configure_jupyter.sh"
}

variable "app_tag" {
  default = "verify"
}

variable "app_description" {
  default = "rc"
}

variable "app_environment" {
  default = "dev"
}
# Get the listing id
# oci compute pic listing list --all | jq ' .data[] | select(."display-name" == "AI (All-in-One) GPU Image for Data Science")."listing-id" '
# or stash it into a variable
# export myid=`oci compute pic listing list --all | jq ' .data[] | select(."display-name" == "AI (All-in-One) GPU Image for Data Science")."listing-id" '  | tr -d '"' `
# echo $myid
variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaachivaakhl6nkqkze3d3f5yqtwabaeomgw6qauya5q4clciacw7qa"
}

# Using the listing id in an exported varaible, get the resource id and resource version
# oci compute pic version list --listing-id $myid | jq ' .data[0] | { "listing-resource-id", "listing-resource-version"  }'
variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1..aaaaaaaa4cqfimd27o5xdz2gd7w2hoarfb32phr6vrd4vphznyb3wxgtzoia"
}

variable "mp_listing_resource_version" {
  default = "2.0"
}

variable "use_marketplace_image" {
  default = true
}

variable "backup_policy" {
  default = "silver"
}

variable "jupyter_password" {
  default = "welcome1"
}

variable "github_repo" {
  default = "https://github.com/JohnSnowLabs/spark-nlp.git"
}

