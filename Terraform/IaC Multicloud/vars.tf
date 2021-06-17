# Connection AWS
variable "amis" {
    type = "map"

    default = {
        "us-east-1" = "ami-085925f297f89fce1"
        "us-east-2" = "ami-07c1207a9d40bc3bd"
    }
}

variable "cidrs_acesso_remoto" {
    type = "list"

    default = ["177.129.184.49/32", "177.128.184.49/32"]
} 

variable "key_name" {

    default = "empresa-terraform"
}

variable "subscription_id" {
  type = string
  default = "<id_subscription>"
}

# Connection Azure
variable "client_id" {
  type = string
  default = "<client_id>"
}
variable "client_secret" {
  type = string
  default = "<secret>"
}
variable "tenant_id" {
  type = string
  default = "<tenant_id>"
}