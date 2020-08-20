variable "vpc_region" {
    description = "region for vpc (ex. us-east-1)"
    type = string
}

variable "availability_zone_1" {
    description = "availability zone"
    type = string
}


variable "availability_zone_2" {
    description = "availability zone"
    type = string
}

variable "vpc_cidr_block" {
    description = "CIDR block of vpc"
    type = string  
}

variable "public_subnet_1" {
    description = "CIDR of public subnet 1"
    type = string
}

variable "public_subnet_2" {
    description = "cidr of public subnet 2"
    type = string
}

variable "open_port" {
    description = "port to open"
    type = number
}

