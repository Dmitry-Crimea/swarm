variable "user_account" {
  description = "user account"
  default = "${file("./user-data/user_account")}"