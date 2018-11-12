# Trainr
A way to create and then destroy AWS resources to train ML models

## Directories
- The data directory is used to create an EBS snapshot containing the training data
- The packer dierctory is used to create the ami that will be used for training
- The trainr directory is used to create an EC2 instance that will train the model and push it to S3
```
.
├── README.md
├─  secrets.json   <-- Create this
├─  secrets.tfvars <-- Create this
├── data
│   ├── data.tf
│   ├── trainr.auto.tfvars
│   └── variables.tf
├── packer
│   ├── trainr.json
│   ├── vars_trainr.json
└── trainr
    ├── trainr.auto.tfvars
    ├── trainr.tf
    └── variables.tf
```

## Tutorial (OSX)
This tutorial goes through how I use this project to train my models. In this case we are training a CNN on the CIFAR-10 dataset.

### Prerequisites: Terraform and Packer Credentials
1. Install Packer and Terraform with `brew install packer` and `brew install terraform`
2. Create an IAM group with the following permissions: [AmazonEC2FullAccess, AmazonS3FullAccess]
3. Create an IAM user and add it to the group. Note the access key and secret key. We will need this to provision AWS resources.
4. Use the keys to create a secrets.tfvars and a secrets.json file they are used for Terraform and Packer respectively.

secrets.tfvars
```
access_key="YOUR_ACCESS_KEY"
secret_key="YOUR_SECRET_KEY"
```

secrets.json
```
{
  "access_key": "YOUR_ACCESS_KEY",
  "secret_key": "YOUR_SECRET_KEY"
}
```

### Building the AMI

### Creating the EBS Snapshot

### Provisioning with Terraform
