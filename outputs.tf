output "bastion_public_ip" {
  description = "The public IP address of the bastion server"
  value       = aws_eip.ep_bastion_eip[0].public_ip
  depends_on = [aws_eip.ep_bastion_eip]
}

output "bastion_public_dns" {
  description = "The public DNS address of the bastion server"
  value       = aws_eip.ep_bastion_eip[0].public_dns

  depends_on = [aws_eip.ep_bastion_eip]
}

output "database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.ep_database_dev.address
}

output "database_port" {
  description = "The port of the database"
  value       = aws_db_instance.ep_database_dev.port
}
