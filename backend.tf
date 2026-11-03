terraform {

  backend "s3" {

    #bucket name - this is where statetf will bw stored
    bucket = "dev-terraform-state-defitha"

    #path
    key    = "three-tier-app/terraform.tfstate"
    region = "ap-south-1"

    #state locking
    dynamodb_table = "terraform-state-lock"

    #state file is encrypted in s3
    encrypt = true
  }
}