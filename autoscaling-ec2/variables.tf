variable "region" {
 description = "AWS region for hosting our your network"
 default = "us-west-2"
}

variable "instance_count" {
 description = "How many instances do you want to have in your cluster?"
 default = 1
 }

variable "minimum_size" {
 description = "What is the lowest number of instances"
 default = 1
 }

variable "maximum_size" {
 description = "What is the highest number of instances"
 default = 2
 }

variable "key_name" {
 description = "Key pair filename"
 default = "ExampleKeyPair"
}
