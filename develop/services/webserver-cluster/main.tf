terraform {
  required_version = ">= 0.12, < 0.13"
}


provider "aws" {
  region = "us-east-1"


  version = "~> 2.0"
}


module "vpc" {

    source              = "../../../modules/services/vpc"
    vpc_region          = var.vpc_region
    availability_zone_1 =  var.availability_zone_1
    availability_zone_2 =  var.availability_zone_2                   
    vpc_cidr_block      =  var.vpc_cidr_block
    subnet_1            =  var.subnet_1
    subnet_2            =  var.subnet_2
    open_port           =  var.open_port


}


module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"

    cluster_name          = var.cluster_name
    ami_image             = var.ami_image  
    instance_type         = var.instance_type
    port_app              = var.port_app
    min_size              = var.min_size
    max_size              = var.max_size
    vpc_id                = module.vpc.vpc_id
    vpc_security_group_id = module.vpc.vpc_security_group_id
    asg_subnet_1          = module.vpc.subnet_1_id
    asg_subnet_2          = module.vpc.subnet_2_id
    
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

output "elb_dns_name" {
    value = module.webserver_cluster.elb_dns_name
}