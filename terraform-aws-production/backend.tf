terraform {
  backend "s3" {
    bucket         = "terraform-aws-production-tfstate-bkt"
    key            = "terraform_aws_production.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform_aws_production-table"
  }
}
