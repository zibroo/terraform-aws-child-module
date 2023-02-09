#  Instances 
resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type 
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.sg.id]
  tags = {
    Name = "instances"
  }
  user_data = file("script.sh")
}

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.target.arn
  for_each         = aws_instance.web
  target_id        = each.value.id
  port             = 80

}

#Security Group
resource "aws_security_group" "sg" {
  vpc_id = data.terraform_remote_state.ibraim.outputs.vpc-id



  dynamic "ingress" {
    for_each = local.ingress_rules
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
