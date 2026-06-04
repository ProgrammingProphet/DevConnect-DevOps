terraform {
  backend "s3" {
    # Replace these values with your actual state bucket and DynamoDB table (for locking)
    bucket         = "devconnect-terraform-state-bucket-replace-me"
    key            = "devconnect/dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "devconnect-terraform-state-lock"
  }
}
