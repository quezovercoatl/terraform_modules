##### VARIABLES #####

variable "public_cidrs" {
  type = list
  default = [["10.10.100.0/24"], ["10.10.101.0/24"]]
}

variable "private_cidrs" {
  type = list
  default = [["10.10.13.0/24", "10.10.14.0/24"]]
}
