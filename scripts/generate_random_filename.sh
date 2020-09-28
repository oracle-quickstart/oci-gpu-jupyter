#!/bin/bash 

#
# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# The Universal Permissive License (UPL), Version 1.0
#

# Implement the external data provider for Terraform. For details see:
# https://www.terraform.io/docs/providers/external/data_source.html
# This is used to generate a unique filename based on 12 characters.


# For Mac's (or BSD) LC_CTYPE is needed so:
R_FILENAME=$(cat /dev/urandom | env LC_CTYPE=C tr -cd 'a-f0-9' | head -c 12 )

# For other Linux distros use:
# R_FILENAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 12)

# Use jq to generate the JSON. Value add from jq is the JSON is properly encoded.
echo $(jq -n --arg r_filename "$R_FILENAME" '{ "r_filename" : $r_filename }' )

exit 0
