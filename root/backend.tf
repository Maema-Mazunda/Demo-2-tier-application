terraform {

  backend "s3" {
    bucket         = "tfstate-piyush-100"
    key            = "backend/demo-2-tier-application.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend"
  }
}