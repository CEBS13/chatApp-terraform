provider "aws" {
    profile = "default"
    region = var.vpc_region
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_1
    availability_zone = var.availability_zone_1
}

resource "aws_subnet" "subnet_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_2
    availability_zone = var.availability_zone_2
}

resource "aws_internet_gateway"  "gateway"{
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main"
    }
}

resource "aws_route_table" "vpc_public_sn" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
    }
}

resource "aws_route_table_association" "route_table_sn_1" {
    subnet_id = aws_subnet.subnet_1.id
    route_table_id = aws_route_table.vpc_public_sn.id
}

resource "aws_route_table_association" "route_table_sn_2"{
    subnet_id = aws_subnet.subnet_2.id
    route_table_id = aws_route_table.vpc_public_sn.id
}

resource "aws_security_group" "vpc_main_sg" {
    name = "public_access_sg"
    description = "give public access security group"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "SSH Access"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  
    }

    ingress {
        description = "Nodejs"
        from_port = var.open_port
        to_port =  var.open_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

output "vpc_id" {
    value = aws_vpc.main.id
    description = "vpc id"
}

output "vpc_security_group_id" {
    value = aws_security_group.vpc_main_sg.id
    description = "Id for vpc security group"
}


output "subnet_1_id" {
    value = aws_subnet.subnet_1.id
    description = "Id for public subnet 1"
}


output "subnet_2_id" {
    value = aws_subnet.subnet_2.id
    description = "id for public subnet 2"
}
