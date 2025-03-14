variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to deploy"
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "The name of the key pair"
  default     = "jenkins-server-key-new" # Updated key pair name to avoid duplicate error
}

variable "public_key_path" {
  description = "The path to the public key file"
  default     = "/home/username/.ssh/jenkins-server-key.pub" # Update with your path
}

variable "security_group_name_prefix" {
  description = "The prefix for the security group name"
  default     = "allow_all_"
}

variable "bucket_name_prefix" {
  description = "The prefix for the S3 bucket name"
  default     = "your-unique-bucket-name"
}