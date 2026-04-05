#VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available" {}


# public subnets
resource "aws_subnet" "pub_sub_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_1a_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.project_name}-public-subnet-1a"
  }
}
resource "aws_subnet" "pub_sub_2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_2b_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.project_name}-public-subnet-2b"
  }
}



# route tabale
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-rt"
  }
}

# public subnet associate to the route tabke
resource "aws_route_table_association" "pub_sub_1a_association" {
  subnet_id      = aws_subnet.pub_sub_1a.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "pub_sub_2b_association" {
  subnet_id      = aws_subnet.pub_sub_2b.id
  route_table_id = aws_route_table.rt.id
}





# private subnets
resource "aws_subnet" "pri_sub_3a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_3a_cidr
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.project_name}-private-subnet-3a"
  }
}

resource "aws_subnet" "pri_sub_4b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_4b_cidr
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.project_name}-private-subnet-4b"
  }
}


resource "aws_subnet" "pri_sub_5a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_5a_cidr
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.project_name}-private-subnet-5a"
  }
}

resource "aws_subnet" "pri_sub_6b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_6b_cidr
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.project_name}-private-subnet-6b"
  }
}

