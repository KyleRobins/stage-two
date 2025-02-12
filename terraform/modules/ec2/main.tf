resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "Security group for FastAPI application"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0e1bed4f06a3b463d"  # Ubuntu 22.04 LTS in us-east-1
  instance_type = var.instance_type

  subnet_id                   = var.subnet_id
  vpc_security_group_ids     = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  key_name                   = var.ssh_key_name

  user_data = <<-EOF
              #!/bin/bash
              # Update and install dependencies
              apt-get update
              apt-get install -y docker.io nginx git
              systemctl start docker
              systemctl enable docker
              
              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Clone the repository
              git clone https://github.com/KyleRobins/stage-two.git /app
              cd /app

              # Configure Nginx
              cat > /etc/nginx/sites-available/fastapi <<'EOL'
              server {
                  listen 80;
                  server_name _;

                  location / {
                      proxy_pass http://localhost:8000;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                  }
              }
              EOL

              # Enable the Nginx site
              ln -s /etc/nginx/sites-available/fastapi /etc/nginx/sites-enabled/
              rm /etc/nginx/sites-enabled/default
              systemctl restart nginx

              # Build and run the application
              cd /app
              docker-compose up -d
              EOF

  tags = {
    Name        = "${var.environment}-app-server"
    Environment = var.environment
  }
} 