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

resource "azurerm_virtual_machine" "thevm" {
	name="table4dsvmtrf"
	location="${var.location}"
	resource_group_name="${var.rg}"
	 network_interface_ids=["${azurerm_network_interface.mynic.id}"]
	 vm_size="Standard_DS1_v2"
	 storage_os_disk {
		 name="theosdisk"
		 caching="ReadWrite"
		 create_option="FromImage"
		 managed_disk_type="Premium_LRS"
	}



storage_image_reference{
	publisher="Canonical"
	offer="UbuntuServer"
	sku="16.04-LTS"
	version="latest"
}
os_profile{
	computer_name="table4dsvmtrf"
	admin_username="azureops"
}
os_profile_linux_config{
	disable_password_authentication=true
	ssh_keys{
	path="/home/azureops/.ssh/authorized_keys"
	key_data="${file("~/.ssh/id_rsa.pub")}"
	}
}
	boot_diagnostics{
		enabled="true"
		storage_uri="${azurerm_storage_account.mystorage.primary_blob_endpoint}"	
	}
tags{
	environment="Testing"
}
}
resource "null_resource" "upload"{
	provisioner "file"{
        source="/home/azureops/terraform/azure/table4ds1thegraph.svg"
        destination="./thegraph.svg"
        connection{
		host="${azurerm_public_ip.myip.ip_address}"
                type="ssh"
                user="azureops"
        }
   }	
}

