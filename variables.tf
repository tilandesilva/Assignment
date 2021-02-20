variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/22"
  description = "VPC cidr as a String"

}
variable "azs" {
  type = list(string)
  default = ["ap-south-1a","ap-south-1b"]
  description = "Availability Zones to create subnets on"
}
variable "vpc_name" {
  type = string
  default = "cap-markets"
  description = "VPC Name"
}
variable "pub_subnets_cidr" {
  type = list(string)
  default = ["10.0.2.0/24","10.0.3.0/24"]
  description = "CIDR of the Public Subnets"
}