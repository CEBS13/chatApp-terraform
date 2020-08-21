# chatapp-terraform

This folder contains a Terraform configuration that deploys a web server cluster (using EC2), in an Amazon Web Services (AWS) account. It contains a module of  VPC with two subnets in different availability zones.It also contains a module of web server cluster with an Auto Scaling Group and an Elastic Load Balancer. With the use of the user_data we can update the server and start the configuration process of our servers. We install git and ansible. Once installed we clone the ansible playbook and deploy our nodejs app.

You can take a look at the following github repositories that i used:

The ansible playbook that gets cloned in the servers

https://github.com/CEBS13/node-ansible

First version of the configuration code of the terraform code.

https://github.com/CEBS13/terraform-chatApp

Node app to deploy on the servers.

https://github.com/CEBS13/Chat-App-using-Socket.io





# Prerequisites

- You must have Terraform installed on your computer.

- You must have an Amazon Web Services (AWS) account.

configure your [AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) access keys as environment variables:
```bash
    $ aws configure
      AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
      AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
      Default region name [None]: us-west-2
      Default output format [None]: json
  ```
# Run
to deploy the code clone the repository and head over chatapp-terraform\terraform-chatapp\develop\services\webserver-cluster
```
terraform init
terraform apply
```
After the configuration is done you should see the loadbalancer dns name to acces the app

```
Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

elb_dns_name = main-elb-004815162342.us-east-1.elb.amazonaws.com
```

For clean up
```
terraform destroy
```

# Modules
## webserver service

This service is build upon two modules VPC and webserver-cluster. All the variables are ready in the variables.tf.

```hcl
    module "vpc" {

        source              = "../../../modules/services/vpc"
        vpc_region          = var.vpc_region
        availability_zone_1 =  var.availability_zone_1
        availability_zone_2 =  var.availability_zone_2                   
        vpc_cidr_block      =  var.vpc_cidr_block
        subnet_1            =  var.subnet_1
        subnet_2            =  var.subnet_2
 # ------ port we want open for our app to use --------
        open_port           =  var.open_port
   }
```



```hcl
module "webserver_cluster" {

    source = "../../../modules/services/webserver-cluster"

    cluster_name          = var.cluster_name
    instance_type         = var.instance_type
    # ---- port for the app to run default value: 5000 ------
    port_app              = var.port_app
    # ------ cluster sizes ---------------
    min_size              = var.min_size
    max_size              = var.max_size
    #------------------------------------
    vpc_id                = module.vpc.vpc_id
    vpc_security_group_id = module.vpc.vpc_security_group_id
    asg_subnet_1          = module.vpc.subnet_1_id
    asg_subnet_2          = module.vpc.subnet_2_id
    
}
```

```hcl

resource "aws_autoscaling_schedule" "business_hours" {
    scheduled_action_name       = "scale-out-during-buisiness-hours"
    min_size                   = 2
    max_size                   = 4
    desired_capacity           = 4
    recurrence                 = "0 9 * * *"
    autoscaling_group_name = module.webserver_cluster.asg_name
}


resource "aws_autoscaling_schedule" "night_hours"{
    scheduled_action_name       = "night-schedule"
    min_size                   = 2
    max_size                   = 4
    desired_capacity           = 2
    recurrence                 = "0 17 * * *"
    autoscaling_group_name = module.webserver_cluster.asg_name
}

```
