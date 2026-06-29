variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "webapp"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "allowed_cidr" {
  description = "CIDR block permitted to SSH to web instance"
  type        = string
  default     = "10.0.0.0/8"
}

# FIX: removed variable "db_password" — declared but never used
# FIX: removed variable "enable_logging" — declared but never used
# NOTE: db_password also had a hardcoded plaintext secret as its default value — never do this