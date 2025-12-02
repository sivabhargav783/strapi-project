terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Networking: VPC
resource "aws_vpc" "strapi_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "strapi-vpc"
  }
}

# 2. Networking: Subnet
# REMOVED availability_zone to let AWS pick where the instance type exists
resource "aws_subnet" "strapi_subnet" {
  vpc_id                  = aws_vpc.strapi_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "strapi-public-subnet"
  }
}

# 3. Networking: Internet Gateway
resource "aws_internet_gateway" "strapi_igw" {
  vpc_id = aws_vpc.strapi_vpc.id

  tags = {
    Name = "strapi-igw"
  }
}

# 4. Networking: Route Table
resource "aws_route_table" "strapi_rt" {
  vpc_id = aws_vpc.strapi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }

  tags = {
    Name = "strapi-route-table"
  }
}

resource "aws_route_table_association" "strapi_rta" {
  subnet_id      = aws_subnet.strapi_subnet.id
  route_table_id = aws_route_table.strapi_rt.id
}

# 5. Security Group
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-security-group"
  description = "Allow SSH and Strapi traffic"
  vpc_id      = aws_vpc.strapi_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Strapi
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 6. SSH Key Pair
resource "tls_private_key" "strapi_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "strapi-key-final-v3"
  public_key = tls_private_key.strapi_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.strapi_key.private_key_pem
  filename = "${path.module}/strapi-key-final-v3.pem"
  file_permission = "0400"
}

# 7. Compute: EC2 Instance
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "strapi_server" {
  ami           = data.aws_ami.ubuntu.id
  
  # Uses the variable from variables.tf
  instance_type = var.instance_type
  
  key_name      = aws_key_pair.generated_key.key_name
  subnet_id     = aws_subnet.strapi_subnet.id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  # 20GB Storage is safe for all types
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file("${path.module}/install_strapi.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "Strapi-Server-HighMem"
  }
}