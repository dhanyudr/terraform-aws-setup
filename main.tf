# Main Terraform Configuration File

provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-server-key-new" # Updated key pair name to avoid duplicate error
  public_key = file(var.public_key_path) # Path to your local public key file
}

resource "aws_security_group" "allow_all" {
  name_prefix = var.security_group_name_prefix
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.jenkins_key.key_name
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "Jenkins-Server"
  }
}

# Data source to fetch the latest Amazon Linux 2 AMI ID
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_name_prefix}-${uuid()}"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

output "instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}