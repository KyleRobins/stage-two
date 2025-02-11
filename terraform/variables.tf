variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "prod"
  type        = string
  default     = "prod"
}

variable "instance_type" {
  description = "t2.micro"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "aws"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
} 