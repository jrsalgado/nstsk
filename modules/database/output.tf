output "database_id" {
  value = aws_db_instance.wordpress_db.id
}

output "database_endpoint" {
  value = aws_db_instance.wordpress_db.endpoint
}
