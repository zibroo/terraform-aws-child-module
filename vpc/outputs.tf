  output "vpc-id" {
    value       = aws_vpc.main.id

  }

output "public_subnet" {
  value       = aws_subnet.public_subnet
}
output "private_subnet" {
  value       = aws_subnet.private_subnet
}
