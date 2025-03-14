terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "path/to/your/key"
    region = "us-east-1"
  }
}
