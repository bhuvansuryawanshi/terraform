# elastic ip
resource "aws_eip" "eip-nat-a" {
  tags = {
    Name = "eip-nat-a"
  }
}
resource "aws_eip" "eip-nat-b" {
  tags = {
    Name = "eip-nat-b"
  }
}

# nat -a
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = var.pub_sub_1a_id

  tags = {
    Name = "nat-a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}

# nat -b
resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = var.pub_sub_2b_id

  tags = {
    Name = "nat-b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}


# route table for nat - a
resource "aws_route_table" "pri_rt_a" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-a.id

  }
  tags = {
    Name = "pri_rt_a"
  }
}


resource "aws_route_table_association" "pri_rt_a_to_pri_sub_3a" {
  subnet_id      = var.pri_sub_3a_id
  route_table_id = aws_route_table.pri_rt_a.id
}

resource "aws_route_table_association" "pri_rt_a_to_pri_sub_4b" {
  subnet_id      = var.pri_sub_4b_id
  route_table_id = aws_route_table.pri_rt_a.id
}


resource "aws_route_table" "pri_rt_b" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-b.id
  }

  tags = {
    Name = "pri_rt_b"
  }

}


resource "aws_route_table_association" "pri_rt_b_to_pri_sub_5a" {
  subnet_id      = var.pri_sub_5a_id
  route_table_id = aws_route_table.pri_rt_b.id
}

resource "aws_route_table_association" "pri_rt_b_to_pri_sub_6b" {
  subnet_id      = var.pri_sub_6b_id
  route_table_id = aws_route_table.pri_rt_b.id
}