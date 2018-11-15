# VNet Stuff
resource "azurerm_virtual_network" "mynet"{
  name="myvnet"
  address_space=["10.0.0.0/16"]
  location="${var.location}"
  resource_group_name="${azurerm_resource_group.thegroup.name}"
  tags{
    environment="Testing"
  }
}
resource "azurerm_subnet" "mysub"{
  name="mysubnet"
  resource_group_name="${azurerm_resource_group.thegroup.name}"
  virtual_network_name="${azurerm_virtual_network.mynet.name}"
  address_prefix="10.0.1.0/24"
}

resource "azurerm_public_ip" "myip"{
  name="table4dsrtfip"
  location="${var.location}"
  resource_group_name="${azurerm_resource_group.thegroup.name}"
  public_ip_address_allocation="Static"
  tags{
   environment="testing"
}
provisioner  "local-exec" {
   command = "echo ${self.ip_address}"
   on_failure = "continue"
}
provisioner "local-exec" {
   command = "echo 'Adios Pub IP'"
   when = "destroy"
}
}
resource "azurerm_network_security_group" "secgroup" {
  name="${var.sec_group_name}"
location="{var.location}"
resource_group_name="${azurerm_resource_group.thegroup.name}"
security_rule{
	name="SSH"
	priority=1003
	direction="inbound"
	access="Allow"
	protocol="Tcp"
	source_port_range="*"
	destination_port_range="22"
	source_address_prefix="*"
	destination_address_prefix="*"
}
tags{
	environment="Testing"
}
}



