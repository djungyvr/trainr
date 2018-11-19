#!/usr/bin/env bash

# For the deep learning AMI
# Activates the python3 + keras2 environment
source activate tensorflow_p36

# Run cifar.py
python3 cifar.py
