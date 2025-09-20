resource "aws_subnet" "main" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = "10.0.14.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.member_name}-subnet"
    Owner   = var.member_name
    Project = "cicd-demo"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = data.aws_route_table.existing.id
}

# Security Group (your personal security group)
resource "aws_security_group" "web" {
  name        = "${var.member_name}-web-sg"
  description = "Security group for web server"
  vpc_id      = data.aws_vpc.existing.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.member_name}-web-sg"
    Owner   = var.member_name
    Project = "cicd-demo"
  }
}

# Key Pair (your SSH key)
resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = file("~/.ssh/ec2-key.pub")

  tags = {
    Name    = "${var.member_name}-key"
    Owner   = var.member_name
    Project = "cicd-demo"
  }
}

# EC2 Instance (your server)
resource "aws_instance" "web" {
  ami                    = "ami-0fe4e90accd5cc34a"
  instance_type          = var.instance_type
  key_name              = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id             = aws_subnet.main.id

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx

              systemctl enable nginx
              systemctl start nginx

              echo "Nginx is ready" > /var/log/setup.log
              EOF

  tags = {
    Name    = "${var.member_name}-web-server"
    Owner   = var.member_name
    Project = "cicd-demo"
  }
}