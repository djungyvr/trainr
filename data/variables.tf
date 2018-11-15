variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-west-2"
}
variable "az" {
  default = "us-west-2a"
}
variable "instance_type" {
  default = "p2.xlarge"
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
