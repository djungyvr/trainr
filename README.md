# Trainr
A way to create and then destroy infra to train ML models

Uses Packer and Terraform

Steps:
1. Copy the training data into a directory, this data will be used to create an EBS snapshot that will be mounted later
2. Builds an AMI with Packer that has Keras with a Tensorflow GPU backend
3. Creates the desired EC2 instance
4. Attaches an EBS containing the training data
5. Copies over ML script to run
6. Save the model and any logs to an S3 bucket
7. Terminates the EC2 instance

## Getting Started
1. create two files containing the aws access\_key and secret\_key
Create a file called secrets.auto.tfvars containing
```
access_key = "YOUR ACCESS KEY"
secret_key = "YOUR SECRET KEY"
```
Create a file called secrets.json containing
```
{
	"access_key":"YOUR ACCESS KEY",
	"secret_key":"YOUR SECRET KEY"
}
```
NOTE: This repo will ignore files in this directory with prefix secrets

2. run `packer build -var-file=secrets.json -var-file=pkr_vars_trainr.json pkr_trainr.json` to build the ami note the ami id
3. run `terraform init`
4. run `terraform apply trainr.tf` to create an instance, supply the variable values when prompted
