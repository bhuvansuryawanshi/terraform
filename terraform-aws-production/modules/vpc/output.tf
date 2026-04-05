output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnet[*].id
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet[*].id
  description = "Private subnet IDs"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat_gw[*].id
  description = "NAT Gateway IDs"
}