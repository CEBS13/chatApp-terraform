variable "cluster_name" {
    description = "The name for all the cluster resources"
    type = string
}

variable "ami_image" {
    description = " image ami"
    type = string
}

variable "instance_type" {
    description = "Type of ec2 instance ex. t2.micro"
}

variable "min_size" {
    description = "minimum number of instances for auto scaling group"
    type = string
}


variable "max_size" {
    description = "maximum number of instances for auto scaling group"
    type = string
}

variable "port_app" {
    description = "port for app"
    type = string
}

# ====== variables from vpc module =======

variable "vpc_id" {
 description = "vpc id from a vpc"
 type = string
}

variable "vpc_security_group_id" {
    description = "security group id"
    type = string
}

variable "asg_subnet_1" {
    description = "block for public subnet"
    type = string
}

variable "asg_subnet_2" {
    description = "block for public subnet"
    type = string
}

