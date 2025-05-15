# Purpose: Configure Terraform to store state remotely in an S3 bucket

terraform {
  backend "s3" {
    bucket         = "your-test-tfstate-bucket"                                 # S3 bucket to store Terraform state
    key            = "test-network/terraform.tfstate"                           # File path in the bucket
    region         = "us-east-1"                                                # AWS region
    dynamodb_table = "terraform-locks"                                          # Table to manage state locks
    encrypt        = true                                                       # Encrypt state file at rest
  }
}