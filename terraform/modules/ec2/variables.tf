variable "environment" {
  description = "prod"
  type        = string
}

variable "vpc_id" {
  description = "fastapi-app-vpc"
  type        = string
}

variable "subnet_id" {
  description = "fastapi-app-subnet"
  type        = string
}

variable "instance_type" {
  description = "t2.micro"
  type        = string
}

variable "ssh_key_name" {
  description = "aws"
  type        = string
} 