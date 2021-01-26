## Use Case
Create a sandboxed machine learning environment that has Tensorflow, SciKit 
and other libraries preconfigured.

## Create ML environment based on Image in Marketplace
The VM is created based on the ![Marketplace Image](https://cloudmarketplace.oracle.com/marketplace/en_US/listing/78643201).  

All the steps described in the marketplace entry are automated. In addition, a functional network is created along with the option of multiple disks that are backed up via policy.

### Using this example
* Copy terraform.template.tfvars to terraform.tfvars
* Update terraform.tfvars with credential information for your tenancy
* Modify variables.tf as needed
* Provision the infrastructure:

```
$ terraform init
$ terraform plan
$ terraform apply
```

### Connect to Jupyter Notebook
* This automation uses ssh redirection for security. This provides for secure access to the notebooks. This approach is not recommended for a team environment.  A sample ssh redirect command is below. The output from terraform apply will display a custom command for your environment.

```
ssh -i <path to private key> -L 8081:localhost:8080 opc@<IP address of VM created>
```

* Use your local browser to connect to the Jupyter
```
http://localhost:8081
http://localhost:8081/notebooks/Examples/deeplearning_bootcamp-master
```

* Enter the password as configured in variables.tf

Known Issue:
If name is changed (app_description, app_tag or app_environment),
the resources are re-created properly, but jupyter notebooks are not
provisioned.




