output "region" {
  value = var.aws_region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_sub_1a" {
  value = aws_subnet.pub_sub_1a.id

}
output "pub_sub_2b" {
  value = aws_subnet.pub_sub_2b.id

}
output "pri_sub_3a" {
  value = aws_subnet.pri_sub_3a.id

}
output "pri_sub_4b" {
  value = aws_subnet.pri_sub_4b.id

}
output "pri_sub_5a" {
  value = aws_subnet.pri_sub_5a.id

}
output "pri_sub_6b" {
  value = aws_subnet.pri_sub_6b.id

}

output "aws_internet_gateway" {
  value = aws_internet_gateway.gw

}