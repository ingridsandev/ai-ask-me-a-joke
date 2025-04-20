terraform {
  backend "s3" {
    bucket         = "ingridsandev-terraform-projects"   
    key            = "terraform/state"           
    region         = "eu-west-1"                 
    dynamodb_table = "terraform-lock"           
    encrypt        = true                       
  }
}