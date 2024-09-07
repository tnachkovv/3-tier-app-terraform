resource "aws_security_group" "ep_web_sg" {
  name        = "ep_web_sg"
  description = "Security group for web server (presentation layer)"
  vpc_id      = aws_vpc.ep_vpc.id

  ingress {
    description = "Allow all traffic through HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my bastion host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "ep_app_sg" {
  name        = "ep_app_sg"
  description = "Security group for app server (application layer)"
  vpc_id      = aws_vpc.ep_vpc.id

  ingress {
    description = "Allow all traffic through HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "8000"
    to_port     = "8000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my bastion host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ep_app_sg"
  }
}

resource "aws_security_group" "ep_bastion_sg" {
  name        = "ep_bastion_sg"
  description = "Security group for test web servers"
  vpc_id      = aws_vpc.ep_vpc.id

  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my local computer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ep_bastion_sg"
  }
}

resource "aws_security_group" "ep_db_sg" {
  name        = "ep_db_sg"
  description = "Security group for ep postgres database"
  vpc_id      = aws_vpc.ep_vpc.id
  ingress {
    description     = "Allow Postgres traffic only from the application sg"
    from_port       = "5432"
    to_port         = "5432"
    protocol        = "tcp"
    security_groups = [aws_security_group.ep_app_sg.id]
  }
  tags = {
    Name = "ep_db_sg"
  }
}

resource "aws_db_subnet_group" "ep_db_subnet_group" {
  name        = "ep_db_subnet_group"
  description = "DB subnet group for test"
  subnet_ids  = [for subnet in aws_subnet.ep_private_db_subnet : subnet.id]
}