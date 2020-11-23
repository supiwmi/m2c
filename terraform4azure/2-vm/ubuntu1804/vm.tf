# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"
  #version = "=2.20.0"
}

# refer to a resource group
data "azurerm_resource_group" "ExistingVMRG" {
  name = "RG-TF-VM-Identity"
}

# refer to a resource group
data "azurerm_resource_group" "ExistingNetworkRG" {
  name = "RG-TF-VM-Network"
}

#refer to a subnet
data "azurerm_subnet" "ExistingNetworkRG" {
  name                 = "subnet1-internal-dmz"
  virtual_network_name = "TFVNet5Subnets"
  resource_group_name  = "RG-TF-VM-Network"
}

# Create public IPs
resource "azurerm_public_ip" "ExistingNetworkRG" {
  name                         = "gitlabdocker-RG-TF-VM-Network"
  location                     = "${data.azurerm_resource_group.ExistingNetworkRG.location}"
  resource_group_name          = "${data.azurerm_resource_group.ExistingNetworkRG.name}"
  public_ip_address_allocation = "dynamic"
  sku                          = "Basic"
}

# create a network interface
resource "azurerm_network_interface" "ExistingNetworkRG" {
  name                = "gitlabdocker-RG-TF-VM-Network"
  location            = "${data.azurerm_resource_group.ExistingNetworkRG.location}"
  resource_group_name = "${data.azurerm_resource_group.ExistingNetworkRG.name}"

  ip_configuration {
    name                          = "gitlabdocker"
    subnet_id                     = "${data.azurerm_subnet.ExistingNetworkRG.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.ExistingNetworkRG.id}"
  }
}

/**********************************************************
#Create Boot Diagnostic Account
resource "azurerm_storage_account" "sa" {
 name                     = "vmdiag4tf"
 resource_group_name      = "RG-TF-SA-Storage"
 location                 = "southeastasia"
 account_tier             = "Standard"
 account_replication_type = "LRS"
 tags = {
   environment = "Boot Diagnostic Storage"
   CreatedBy = "Admin"
 }
}
**********************************************************/

# Create virtual machine
resource "azurerm_virtual_machine" "ExistingNetworkRG" {
  name                  = "gitlabdocker" # This is the VM Name in Azure Portal
  location              = "${data.azurerm_resource_group.ExistingVMRG.location}"
  resource_group_name   = "${data.azurerm_resource_group.ExistingVMRG.name}"
  network_interface_ids = ["${azurerm_network_interface.ExistingNetworkRG.id}"]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination    = true # It will delete when we destroy
  delete_data_disks_on_termination = true # We don't have to worry about costs

/*
 storage_image_reference {
   publisher = "openLogic"
   offer = "CentOS"
   sku = "7_8-gen2"
   version = "latest"
 }

*/
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  storage_os_disk {
    name              = "gitlabdocker"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "gitlabdocker" # This is the OS name - login prompt
    admin_username = "suparuek"
    admin_password = "Password12345!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Terraform Project - centos 7.8 Gen2"
    CreatedBy   = "Suparuek P"
  }
  /*
 boot_diagnostics {
       enabled     = "true"
       storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
   }
*/

  /*
*************************************************
คำสั่งที่ใช้กับ terraform
*************************************************
คำสั่ง init รันแค่ครั้งแรกครั้งเดี่ยวเพื่อ load software มาจาก terraform website
   terraform init

คำสั่ง plan เป็นการบอกว่าจะสร้าง(ทำอะไรบ้าง) นอกจากนี้ยังช่วยเช็คว่าพิมพ์คำสั่งผิดหรือไม่ ทุกครั้งที่แก้ code
   terraform plan

คำสั่ง apply เป็นการสั่งให้มันสร้างขึ้นมา -auto-approve เพื่อที่จะได้ไม่ต้องมาตอบ yes เพื่อ confirm
   terraform apply -auto-approve

คำสั่ง destroy จะใช้เมื่อเราต้องการลบทุกอย่างทิ้ง และถ้าจะสร้างใหม่ต้องรัน plan และ apply เพื่อสร้างใหม่
   terraform destroy -auto-approve

*************************************************
*/


}
