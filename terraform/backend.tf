terraform {
  backend "s3" {
    bucket         = "ingridsandev-ai-projects"   
    key            = "terraform/state"           
    region         = "us-east-1"                 
    dynamodb_table = "terraform-lock"           
    encrypt        = true                       
  }
}