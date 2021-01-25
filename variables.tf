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

# A region is required to identify where the resources will live. An example is 'us-ashburn-1'
variable "region" {
  default = ""
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
    us-phoenix-1   = "<OCID for image in phoenix region>"
    us-ashburn-1   = "<OCID for image in ashburn region>"
    eu-frankfurt-1 = "<OCID for image in frankfurt region>"
    uk-london-1    = "<OCID for image in london region>"
  }
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
# The mp_listing_id will contain the characters ocid1.appcataloglisting at the beginning of the ocid.
variable "mp_listing_id" {
  default = ""
}

# Using the listing id in an exported varaible, get the resource id and resource version
# oci compute pic version list --listing-id $myid | jq ' .data[0] | { "listing-resource-id", "listing-resource-version"  }'
# The mp_listing_resource_id will contain the characters ocid1.image at the beginning of the ocid value.
variable "mp_listing_resource_id" {
  default = ""
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

# A password for jupyter is required.
variable "jupyter_password" {
  default = ""
}

# Set up environment for sparkNLP including: java, spark, scala, hadoop
# default = "configure_jupyter_sparknlp"

# Set up environment for completing configuration of JupyterNotebooks and cx_oracle 
# default = "configure_jupyter"

variable "script_to_run" {
  default = "configure_jupyter_sparknlp"
}

# Spark NLP Workshop: https://github.com/JohnSnowLabs/spark-nlp-workshop
# Spark NLP Repo: https://github.com/JohnSnowLabs/spark-nlp

# Tenssorflow example notebooks 
# default = "https://github.com/aymericdamien/TensorFlow-Examples"

# PyTorch Learning 
# default = "https://pytorch.org/tutorials/beginner/deep_learning_60min_blitz.html"
variable "github_repo" {
  default = "https://github.com/JohnSnowLabs/spark-nlp-workshop"
}

