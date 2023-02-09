##################################################################################################################################
# EC2 INSTANCES
##################################################################################################################################
resource "aws_instance" "instance" {
  ami                         = var.ami
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type 
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.sg.id]
  tags = {
    Name = "instances"
  }
  user_data = file("script.sh")
}

##################################################################################################################################
# SECURITY GROUP
##################################################################################################################################
resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id



  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_block
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform-sg"
  }
}
##################################################################################################################################
# LAUNCH TEMPLATE
##################################################################################################################################
resource "aws_launch_template" "launch_template" {
  name = "${local.name}-lt"
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.ebs_volume_size
    }
  }
  image_id                             = var.ami
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type 
  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    security_groups             = ["${aws_security_group.sg.id}"]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "instance-lt-${var.name}"
    }
  }
  user_data = filebase64("${path.module}/script.sh")
}

##################################################################################################################################
# AMI DATA SOURCE
##################################################################################################################################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}



