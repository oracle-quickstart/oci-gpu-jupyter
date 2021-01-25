# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Documentation on using Terraform with OCI is available at:
# https://docs.cloud.oracle.com/iaas/Content/API/SDKDocs/terraform.htm?TocPath=Developer%20Tools%20|Terraform%20Provider|_____0

# Required parameters
tenancy_ocid = "<Replace with ocid for your tenancy.>"

user_ocid = "<Replace with user for to log in with>"

fingerprint = "<Replace with fingerprint for your key.>"

# If your private key has a password, enter it here.
private_key_password = "<Provide passwrd if needed>"

private_key_path = "<Full path to private key file>"

# The ocid for a compartment will include compartment in the name.

compartment_ocid = "<Can be retrieved using OCI cloud console."

# Parameters for execution of this example.

# Which region are the resources created in ? An example is 'uk-london-1'
region = "<Region of resources>"

# Provide a public key that is injected into the instances on creation.
ssh_public_key = "<Replace with path to public key>"
