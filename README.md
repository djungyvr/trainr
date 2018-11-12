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
