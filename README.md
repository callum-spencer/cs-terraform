# cs-terraform

This terraform repo is being used to explore not deploying terraform in the traditional way of a state file per environment but rather a state file for each service, at the minute we are deploying an ECS service for a simple web container and also managing IAM users in terraform which access other environments via IAM roles and MFA.

For running the terraform we have github actions files which initiate a plan and apply. You can also run it via your command line by first copying one of the env/ files to '.env' and then running terraform plan/apply etc

This repo is dependant on the web portal repo deploying the container image to ECR also.
