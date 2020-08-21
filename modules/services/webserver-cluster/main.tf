data "template_file" "user_data" {
   template = file("${path.module}/user-data.sh")
}

resource "aws_launch_configuration" "config_ec2" {
    image_id = var.ami_image
    instance_type = "t2.micro"
    security_groups = [var.vpc_security_group_id]
    associate_public_ip_address = true
    user_data = data.template_file.user_data.rendered

    lifecycle {
        create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "main_asg" {
    name = "${var.cluster_name}-${aws_launch_configuration.config_ec2.name}"
    launch_configuration = aws_launch_configuration.config_ec2.name
    vpc_zone_identifier = local.subnets_list
    load_balancers = [aws_elb.main_elb.name]
    health_check_type = "ELB"

    min_size = var.min_size
    max_size = var.max_size
    
    min_elb_capacity = var.min_size

    lifecycle {
        create_before_destroy = true
    }
    tag {
        key = "Name"
        value = var.cluster_name
        propagate_at_launch = true
    }
}

#  load balancer

resource "aws_elb" "main_elb" {
  name               = "main-elb"
  security_groups = [aws_security_group.elb.id]
  subnets = local.subnets_list

    
  listener {
    instance_port     = var.port_app
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
    
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.port_app}/"
    interval            = 30
  }

  
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}




resource "aws_lb_cookie_stickiness_policy" "main_policy_elb" {
  name                     = "sticky-policy"
  load_balancer            = aws_elb.main_elb.id
  lb_port                  = 80
  cookie_expiration_period = 600
}




resource "aws_security_group" "elb" {
    name = "${var.cluster_name}-elb"
    vpc_id = var.vpc_id

    ingress{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


locals {
    subnets_list = [var.asg_subnet_1, var.asg_subnet_2]
}


output "asg_name" {
    value = aws_autoscaling_group.main_asg.name
    description = "the name of the auto scaling group"
} 


output "elb_dns_name" {
    value        = aws_elb.main_elb.dns_name
    description  = "The domain name of the load balancer"

}