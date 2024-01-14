terraform {
  required_version = "~> 1.0"

  // 여기서 key 를 세팅할 수 있는 방법이 있을까? 
  backend "s3" {
    bucket         = "tf-sample-remote-state"
    key            = "global/prod/sample/applications/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "tf-sample-state-lock"
    encrypt        = true
    profile        = "default"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = var.aws_profile
}
