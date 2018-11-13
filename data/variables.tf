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
variable "size" {}
variable "local_script_path" {}
variable "remote_script_path" {}
