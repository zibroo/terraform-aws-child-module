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
  type = string 
  default = "t2.micro"
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
variable "vpc_id" {
  
}
variable "var.ebs_volume_size" {
  default = 10 
  type = number
  
}
variable "subnet_ids" {
  type = list
  #[aws_subnet.example1.id, aws_subnet.example2.id]
}