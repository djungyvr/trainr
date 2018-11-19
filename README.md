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

## Tutorial (OSX) WIP!!
This tutorial goes through how I use this project to train my models. In this case we are training a CNN on the CIFAR-10 dataset.
You may need to request to increase your EC2 service limits for the more powerful instances.

### Prerequisites: Terraform and Packer Credentials
1. Install Packer and Terraform with `brew install packer` and `brew install terraform`
2. Create an IAM group with the following permissions: [AmazonEC2FullAccess, AmazonS3FullAccess]
3. Create an IAM user and add it to the group. Note the access key and secret key. We will need this to provision AWS resources.

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
4. Use the keys to create a secrets.tfvars and a secrets.json file they are used for Terraform and Packer respectively.
5. Create an EC2 Key Pair create a directory and file `.ssh/<secret-key>.pem` inside data and trainr, by default expects the key name to be `trainr` and the secret key file to be named `trainr.pem`
6. Run `make init` to initialize Terraform states

### Building the AMI
To build the ami, run `packer build -var-file=secrets.json -var-file=vars_trainr.json packer/trainr.json`

What this will do is create an AMI that has everything needed to run Keras with a Tensorflow-GPU backend

### Collecting the Training Data
To create the EBS containing the training data copy the collection script to the data directory with `cp tutorial/collect.sh data`

Then run `make create-snapshot` to create an EBS snapshot containing the data collected by collect.sh

This will create an EBS with the training data that will be mounted in the next step

### Training the Model
To create the EC2 instance that will train the model first copy the training shell script and Keras script with `cp tutorial/train.sh trainr` and `cp tutorial/cifar.py trainr`

Then run `make train` to create the instance that will run the training scripts

It will ask for the AMI to use, the EBS snapshot, and the python script that you wish to run
