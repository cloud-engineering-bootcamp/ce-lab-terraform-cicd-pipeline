output "vpc_id" {
  description = "VPC identifier"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet identifiers"
  value       = aws_subnet.public[*].id
}