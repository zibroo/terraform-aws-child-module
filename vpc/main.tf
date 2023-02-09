#VPC
resource "aws_vpc" "final_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.name}-vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.final_vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Elastic Ip
resource "aws_eip" "nat" {

  vpc = true
}

# NAT GW
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public_subnet[*].id,0)

  tags = {
    Name = "${var.name}-nat_gw"
  }
  depends_on = [aws_internet_gateway.igw]
}

#Subnets public
resource "aws_subnet" "public_subnet" {
  count = var.public_count

  vpc_id = aws_vpc.final_vpc.id

  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.public_availability_zones[count.index]
  tags = {
    Name = "public-subnet-${var.name}"
  }
}

#Assocition rt to public subnets
resource "aws_route_table_association" "public_association" {
  count          =  var.public_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Subnets private
resource "aws_subnet" "private_subnet" {
  count = var.private_count

  vpc_id = aws_vpc.final_vpc.id

  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.private_availability_zones[count.index]
  tags = {
    Name = "private-subnet-${var.name}"
  }

}


#Assocition rt to private subnets
resource "aws_route_table_association" "private_association" {
  count          = var.private_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}


#Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.final_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-table"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.final_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.name}-private-table"
  }
}

