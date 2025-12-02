output "strapi_public_ip" {
  description = "The Public IP address of the Strapi Server"
  value       = aws_instance.strapi_server.public_ip
}

output "strapi_url" {
  description = "The URL to access Strapi (Wait 5 mins)"
  value       = "http://${aws_instance.strapi_server.public_ip}:1337"
}

output "ssh_connection_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i strapi-key-final-v3.pem ubuntu@${aws_instance.strapi_server.public_ip}"
}