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

variable "subnet_1" {
    description = "CIDR of  subnet 1"
    type = string
}

variable "subnet_2" {
    description = "cidr of subnet 2"
    type = string
}

variable "open_port" {
    description = "port to open"
    type = number
}

