module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  aws_region  = var.aws_region
}

module "ec2" {
  source = "../../modules/ec2"

  environment   = var.environment
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  instance_type = var.instance_type
  ssh_key_name  = var.ssh_key_name
}

output "public_ip" {
  value = module.ec2.public_ip
} 