variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name for resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins server"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
}