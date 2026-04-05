terraform {
  backend "s3" {
    bucket         = "two-tire-architreture-tfstate-bucket"
    key            = "backend/two-tier-architecture-tfstate-bucket.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "two-tire-architreture-remote-backend"
  }
}
