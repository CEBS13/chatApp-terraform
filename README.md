# chatapp-terraform


# Prerequisites

- You must have Terraform installed on your computer.

- You must have an Amazon Web Services (AWS) account.

Configure your [AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) access keys as environment variables:
```bash
    $ aws configure
      AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
      AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
      Default region name [None]: us-west-2
      Default output format [None]: json
  ```

# web-server module

```hcl
    module "vpc" {

        source              = "../../../modules/services/vpc"
        vpc_region          = var.vpc_region
        availability_zone_1 =  var.availability_zone_1
        availability_zone_2 =  var.availability_zone_2                   
        vpc_cidr_block      =  var.vpc_cidr_block
        public_subnet_1     =  var.public_subnet_1
        public_subnet_2     =  var.public_subnet_2
        open_port           =  var.open_port
```


module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"

    cluster_name          = var.cluster_name
    instance_type         = var.instance_type
    port_app              = var.port_app
    min_size              = var.min_size
    max_size              = var.max_size
    vpc_id                = module.vpc.vpc_id
    vpc_security_group_id = module.vpc.vpc_security_group_id
    asg_public_subnet_1       = module.vpc.public_subnet_1_id
    asg_public_subnet_2       = module.vpc.public_subnet_2_id
    
}

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

``


Deploy the code:

terraform init
terraform apply


Clean up when you're done:

terraform destroy
