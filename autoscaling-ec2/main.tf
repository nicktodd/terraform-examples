terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

# Obtain a region independent list of availability zones
data "aws_availability_zones" "all" {
  state = "available"
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

provider "aws" {
  profile = "default"
  # reference a variable from the variables.tf file
  region  = var.region
}

## We can now create the required resources
## Launch config, ELB, Security Groups, ASG

# The Launch Configuration
resource "aws_launch_configuration" "my_launch_config" {
  image_id               = data.aws_ami.amazon-linux-2.image_id
  instance_type          = "t2.micro"
  # For now use the same SG as the ELB. This could be changed for a different one to prevent direct access
  security_groups        = [aws_security_group.instance-sg.id]
  key_name               = var.key_name
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum -y install java-1.8.0
              cd /home/ec2-user
              wget http://training.conygre.com/compactdiscapp.jar
              nohup java -jar compactdiscapp.jar > ec2dep.log
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

# The autoscaling group
## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.my_launch_config.id
  min_size = var.minimum_size
  max_size = var.maximum_size
  load_balancers = [aws_elb.my-elb.name]
  availability_zones = data.aws_availability_zones.all.names
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "My Terraform Deployment"
    propagate_at_launch = true
  }
}

# Security Group for the load balancer
resource "aws_security_group" "elb-sg" {
  name = "elb-sg"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for the instances
resource "aws_security_group" "instance-sg" {
  name = "instance-sg"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# The Load balancer
resource "aws_elb" "my-elb" {
  name = "my-elb"
  security_groups = [aws_security_group.elb-sg.id]
  availability_zones = data.aws_availability_zones.all.names
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}