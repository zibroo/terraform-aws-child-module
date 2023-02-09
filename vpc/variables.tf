variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
    description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using"
    type = string
}
variable "name" {
    default = "final-terraform"
    description = "main name for tags"
    type = string
}
variable "public_count" {
    default = 1
    description = "Count of public subnets"
    type = number
}
variable "public_cidr" {
    default = ["10.0.1.0/24"]
    description = "The IPv4 CIDR block for the subnet"
    type = list
}
variable "public_availability_zones" {
    default = ["us-east-1a"]
    description = "AZ for the public subnet"
    type = list
}

variable "private_count" {
    default = 1
    description = "Count of private subnets"
    type = number
}
variable "private_cidr" {
    default = ["10.0.10.0/24"]
    description = "The IPv4 CIDR block for the private subnet"
    type = list
}
variable "private_availability_zones" {
    default = ["us-east-1b"]
    description = "AZ for the private subnet"
    type = list
}
