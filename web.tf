# Security group for the web server
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for the web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH access - restricted to allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr] # FIX: was 0.0.0.0/0 — open SSH is a deliberate misconfiguration
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic" # FIX: added missing description
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #trivy:ignore:AVD-AWS-0104
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.web.id]
  monitoring             = true # FIX: enabled detailed cloudwatch monitoring

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true # FIX: was false
  }

  metadata_options {
    http_tokens = "required" # FIX: enforces IMDSv2, disables IMDSv1
  }

  tags = {
    Name = "${var.project_name}-web"
  }

  # FIX: removed depends_on = [var.vpc_cidr] — variables are not valid depends_on targets
}
