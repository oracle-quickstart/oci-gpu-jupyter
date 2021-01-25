## Variables

* tenancy_ocid -- The OCID of the tenancy. Required, no default.

* user_ocid -- The OCID of the user that will run the terraform script. Required, no default

* fingerprint -- The fingerprint of the key uploaded to OCI. Required, no default.

* private_key_path -- The full pathname of the private key used for OCI authentication. Required, no default.

* private_key_password -- The password to the private key file, if needed.

* region -- The region to create resources in. Required, no default.

* compartment_ocid -- The compartment to create the resources in. Required, no default.

* number_instances -- Number of VM to create jupyter notebooks on. Default is 1.

* instance_shape -- Shape of VM to create. Requried, no default.

* ssh_public_key -- Public key to add to the VM created. Required, no default.

* ssh_private_key -- Private key used to log into the VM and complete configuration. Required, no default.

* AD -- 

* volume_size_in_gbs -- Size of the disk to attach to the VM.

* InstanceImageOCID -- The OCID of for the image to create.

* script_to_run -- The script to execute on creation of VM. Default is configure_jupyter.sh.

* app_tag -- String included in the name of each reasource created and added as a freeform tag. Required, no default.

* app_description -- String added to the name of each resource created. Required, no default.

* app_environment -- String added to the name of each resource created. Required, no default.

* mp_listing_id -- Marketplace listing ID for the image to pull. Required, if use_marketplace_image is 1.

* mp_listing_resource_id -- Resource ID for maketplace listing. Required, if use_marketplace_image is 1.

* mp_listing_resource_version -- Listing Resource Version for marketplace listing. Required if use_marketplace_image is 1.

* use_marketplace_image -- Whether or not to  pull an image from the marketplace. Default is 1.

* backup_policy -- The backup policy the disks are associated with. Default is 'silver'.

* jupyter_password -- The password for all users for the newly created Jupyter notebook. No default is provided.

* github_repo -- The git repo to download and make available for the notebooks. 
