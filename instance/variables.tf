variable "ami" {
  type = string
  default = var.instance_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
}
variable "instance_os" {
  type = string 
  default = "ubuntu"
}
variable "subnet_id" {
  
}
variable "instance_type " {
  
}
variable "name" {
  
}
variable "ingress_rules" {
    type = list 
    default = [
    { port = 80, cidr_block = ["0.0.0.0/0"] },
    { port = 443, cidr_block = ["0.0.0.0/0"] },
    { port = 22, cidr_block = ["0.0.0.0/0"] }
  ]
  
}