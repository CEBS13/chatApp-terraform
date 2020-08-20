variable "vpc_region" {
    description = "region for vpc (ex. us-east-1)"
    type = string
    default = "us-east-1"
}

variable "availability_zone_1" {
    description = "availability zone"
    type = string
    default = "us-east-1a"
}

variable "availability_zone_2" {
    description = "availability zone"
    type = string
    default = "us-east-1c"
}

variable "vpc_cidr_block" {
    description = "CIDR block of vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_1" {
    description = "CIDR of public subnet 1"
    type = string
    default = "10.0.1.0/24"
}

variable "public_subnet_2" {
    description = "cidr of public subnet 2"
    type = string
    default = "10.0.2.0/24"
}

variable "open_port" {
    description = "open port for server"
    type = number
    default = 5000
}
