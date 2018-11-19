variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-west-2" }
variable "az" {
  default = "us-west-2a"
}
variable "size" {
  default = 5
}
variable "key_name" {
  default = "trainr"
}
variable "private_key" {
  default = ".ssh/trainr.pem"
}
variable "script" {
  default = "train.sh"
}
variable "ami" {
  default = "ami-0688c8f24f1c0e235"
}
variable "instance_type" {
  #default = "t2.micro"
  #default = "p2.xlarge"
}
variable "snapshot" {}
variable "keras_script" {}
