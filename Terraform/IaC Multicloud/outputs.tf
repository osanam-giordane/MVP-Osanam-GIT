output "AWS_dev8" {
    value = "${aws_instance.dev8.public_ip}"
}

output "Azure_Linux1" {
    value = "${azurerm_public_ip.myterraformpublicip.ip_address}"
}


output "Azure_Linux2" {
    value = "${azurerm_public_ip.myterraformpublicip2.ip_address}"
}

output "Azure_Linux3" {
    value = "${azurerm_public_ip.myterraformpublicip3.ip_address}"
}