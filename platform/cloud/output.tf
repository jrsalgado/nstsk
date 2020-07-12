output "public_subnets" {
  value       = module.network.public_subnets
  description = "Is the list of publics subnets"
}

output "private_subnets" {
  value       = module.network.private_subnets
  description = "Is the list of privates subnets"
}
  
