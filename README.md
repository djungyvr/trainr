# Trainr
A way to create and then destroy AWS resources to train ML models

## Directories
- The data directory is used to create an EBS snapshot containing the training data
- The trainr directory is used to create an EC2 instance that will train the model and push it to S3
```
.
├── README.md
├─  secrets.tfvars <-- Create this
├── data
│   ├── data.tf
│   ├── trainr.auto.tfvars
│   └── variables.tf
└── trainr
    ├── trainr.auto.tfvars
    ├── trainr.tf
    └── variables.tf
```

## Tutorial (OSX) WIP!!
This tutorial goes through how I use this project to train my models. In this case we are training a CNN on the CIFAR-10 dataset.
You may need to request to increase your EC2 service limits for the more powerful instances.

### Prerequisites
1. Install Terraform with `brew install terraform`
2. Create an IAM group with the following permissions: [AmazonEC2FullAccess, AmazonS3FullAccess]
3. Create an IAM user and add it to the group. Note the access key and secret key. We will need this to provision AWS resources.

secrets.tfvars
```
access_key="YOUR_ACCESS_KEY"
secret_key="YOUR_SECRET_KEY"
```

4. Use the keys to create a secrets.tfvars file they are used for Terraform respectively.
5. Create an EC2 Key Pair create a directory and file `.ssh/<secret-key>.pem` inside data and trainr, by default expects the key name to be `trainr` and the secret key file to be named `trainr.pem`
6. Run `make init` to initialize Terraform states
7. Run `make init-tutorial` to copy over the tutorial files

### Collecting the Training Data
Then run `make create-data` to initialize the EBS. Once completed run `make create-snapshot` to create the EBS snapshot

This will create an EBS with the training data that will be mounted in the next step

Now run `make destroy-data` to destroy the infrastructure except for the EBS

### Training the Model
To train the model run `make train`. This will run the trainr/train.sh file
which calls the trainr/cifar.py. Terraform will ask for the instance type you wish
to use, enter any instance type that has a GPU to take advantage of CUDA. In most cases a p2.xlarge is good enough and for the keras\_script enter cifar.py

Once the training is completed run `make destroy-train`. This will destroy the infrastructure used to train the models. Make sure to run this step or you may be charged a lot.
The tutorial does not store the models anywhere but the train.sh file can be updated to push the Keras model to S3 or some otherplace.
