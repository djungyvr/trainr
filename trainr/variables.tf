variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-west-2"
}
variable "az" {
  default = "us-west-2a"
}
variable "size" {
  default = 1
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
variable "ami" {}
variable "instance_type" {
  #default = "t2.micro"
  #default = "p2.xlarge"
}
