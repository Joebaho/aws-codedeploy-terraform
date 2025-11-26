output "jenkins_server_url" {
  description = "URL to access Jenkins server"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "load_balancer_url" {
  description = "URL to access the web application"
  value       = "http://${aws_lb.web_alb.dns_name}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for CodeDeploy"
  value       = aws_s3_bucket.codedeploy_bucket.bucket
}

output "codedeploy_app_name" {
  description = "Name of the CodeDeploy application"
  value       = aws_codedeploy_app.web_app.name
}

output "codedeploy_deployment_group" {
  description = "Name of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.web_dg.deployment_group_name
}