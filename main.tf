provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "arista-terraform-state-bucket-2026"
    key    = "terraform/activity2/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

# Example 1: Create an S3 bucket (for your website/files)
resource "aws_s3_bucket" "my_web_bucket" {
  bucket = "arista-web-bucket-${random_string.suffix.result}"

  tags = {
    Name        = "Arista Web Bucket"
    Environment = "Dev"
    ManagedBy   = "Terraform"
    Activity    = "DevSecOps-3.1"
  }
}

# Generate random suffix for unique bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Block public access for security
resource "aws_s3_bucket_public_access_block" "security" {
  bucket = aws_s3_bucket.my_web_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# # Example 2: Create an EC2 instance (t2.micro - free tier eligible)
# # Find the latest Amazon Linux 2 AMI
# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# resource "aws_instance" "web_server" {
#   ami           = data.aws_ami.amazon_linux_2.id
#   instance_type = "t2.micro"

#   tags = {
#     Name      = "Arista-Terraform-Server"
#     ManagedBy = "Terraform"
#     Activity  = "DevSecOps-3.1"
#   }
# }

# Output the results
output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.my_web_bucket.bucket
}

# output "ec2_instance_id" {
#   description = "ID of the created EC2 instance"
#   value       = aws_instance.web_server.id
# }

# output "ec2_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = aws_instance.web_server.public_ip
# }