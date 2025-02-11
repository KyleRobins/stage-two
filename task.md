# Deploying a FastAPI Application with Terraform on AWS

## Project Overview

In this project, we deployed a FastAPI application using Terraform to manage AWS infrastructure. The goal was to create a robust, scalable deployment with proper networking, security, and infrastructure as code practices.

## Requirements

- Deploy FastAPI application on AWS
- Use Terraform for infrastructure management
- Configure proper networking with VPC and subnets
- Set up security groups for the application
- Use Ubuntu 22.04 LTS as the base AMI
- Deploy in us-east-1 region
- Store Terraform state in S3

## Solution Architecture

### Infrastructure Components

1. **VPC Setup**

   - Custom VPC with CIDR block 10.0.0.0/16
   - Public subnet in us-east-1a
   - Internet Gateway for public internet access
   - Route tables for network traffic management

2. **EC2 Instance**

   - t2.micro instance type (free tier eligible)
   - Ubuntu 22.04 LTS AMI (ami-0e1bed4f06a3b463d)
   - Security group with ports 22, 80, and 443 open
   - User data script for Docker installation

3. **Security**
   - SSH key pair for secure instance access
   - Security groups limiting access to necessary ports
   - S3 backend for secure state management

## Implementation Details

### 1. Terraform Structure

````plaintext
terraform/
├── environments/
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── modules/
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── variables.tf


### 2. VPC Module

The VPC module creates a networking foundation with:
- VPC with DNS support enabled
- Public subnet for our application
- Internet Gateway for external connectivity
- Route tables for traffic management

### 3. EC2 Module

The EC2 module provisions our application server with:
- Ubuntu 22.04 LTS instance
- Docker pre-installed via user data script
- Security group with necessary ports open
- Public IP for accessibility

### 4. State Management

We use an S3 backend for state management:

```hcl
backend "s3" {
  bucket = "fastapi-app-terraform-state-hng"
  key    = "fastapi-app/terraform.tfstate"
  region = "us-east-1"
}
````

## Deployment Steps

1. **Initialize S3 Backend**

```bash
aws s3api create-bucket \
    --bucket fastapi-app-terraform-state-hng \
    --region us-east-1
```

2. **Configure AWS Credentials**

```bash
aws configure
```

3. **Initialize Terraform**

```bash
cd terraform/environments/prod
terraform init
```

4. **Deploy Infrastructure**

```bash
terraform plan
terraform apply
```

## Security Considerations

1. **Network Security**

   - VPC isolation for resources
   - Security groups limiting access
   - Public subnet only for necessary components

2. **Access Management**
   - SSH key pair for instance access
   - Limited open ports in security groups
   - S3 backend for secure state storage

## Conclusion

This infrastructure setup provides a secure and scalable foundation for our FastAPI application. Using Terraform allows us to version control our infrastructure and make reproducible deployments. The modular structure enables easy maintenance and potential expansion of the infrastructure.

## Future Improvements

1. Add an Application Load Balancer for better scalability
2. Implement auto-scaling groups for high availability
3. Add CloudWatch monitoring and alerts
4. Implement backup strategies
5. Add HTTPS support with ACM certificates

The current setup provides a solid foundation that can be built upon based on future requirements and scaling needs.
