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

## Directories
- The data directory is used to create an EBS snapshot containing the training data
- The packer dierctory is used to create the ami that will be used for training
- The trainr directory is used to create an EC2 instance that will train the model and push it to S3
```
.
├── README.md
├── data
│   ├── data.tf
│   ├── secrets.auto.tfvars <-- Create this
│   ├── trainr.auto.tfvars
│   └── variables.tf
├── packer
│   ├── trainr.json
│   ├── vars_trainr.json
│   └── secrets.json <-- Create this
└── trainr
    ├── secrets.auto.tfvars <-- Create this
    ├── trainr.auto.tfvars
    ├── trainr.tf
    └── variables.tf
```
