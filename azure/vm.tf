resource "azurerm_network_interface" "mynic"{
	name="mynic"
	location="${var.location}"
	resource_group_name="${var.rg}"
	network_security_group_id="${azurerm_network_security_group.secgroup.id}"
	

	ip_configuration{
		name="mynicipconfig"
		subnet_id = "${azurerm_subnet.mysub.id}"
		private_ip_address_allocation="dynamic"
		public_ip_address_id="${azurerm_public_ip.myip.id}"
	}
}
resource "random_id" "randomid"{
	keepers = {
		resource_group="${azurerm_resource_group.thegroup.name}"
	}
	byte_length=8
}
resource "azurerm_storage_account" "mystorage" {
	name="diag${random_id.randomid.hex}"
	resource_group_name="${azurerm_resource_group.thegroup.name}"
	location="${var.location}"
	account_tier="Standard"
	account_replication_type="LRS"
	tags{
		environment="Testing"
	}
}
