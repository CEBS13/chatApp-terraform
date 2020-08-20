module "vpc" {

    source              = "../../modules/services/vpc"
    vpc_region          = var.vpc_region
    availability_zone_1 =  var.availability_zone_1
    availability_zone_2 =  var.availability_zone_2                   
    vpc_cidr_block      =  var.vpc_cidr_block
    public_subnet_1     =  var.public_subnet_1
    public_subnet_2     =  var.public_subnet_2
    open_port           =  var.open_port
}


output "vpc_security_group_id" {
    value = module.vpc.aws_security_group.vpc_main_sg.id
    description = "Id for vpc"
}


output "public_subnet_1_id" {
    value = module.vpc.aws_subnet.public_subnet_1.id
    description = "Id for public subnet 1"
}


output "public_subnet_2_id" {
    value = module.vpc.aws_subnet.public_subnet_2.id
    description = "id for public subnet 2"
}
