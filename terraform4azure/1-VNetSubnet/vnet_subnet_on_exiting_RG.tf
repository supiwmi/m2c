# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"
  #version = "=2.20.0"
}

# refer to a resource group
data "azurerm_resource_group" "ExistingNetworkRG" {
  name = "RG-TF-VM-Network"
}

# Create virtual network - VNet
resource "azurerm_virtual_network" "TFNet" {
  name                = "TFVNet5Subnets"
  address_space       = ["10.1.0.0/16"]
  resource_group_name = "${data.azurerm_resource_group.ExistingNetworkRG.name}"
  location            = "${data.azurerm_resource_group.ExistingNetworkRG.location}"
}

# Create virtual network - internal Subnet1
 resource "azurerm_subnet" "tfsubnet1" {
  name                = "subnet1-internal-dmz"
  resource_group_name = "${data.azurerm_resource_group.ExistingNetworkRG.name}"
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefix       = "10.1.1.0/24"
}

# Create virtual network - internal Subnet2
resource "azurerm_subnet" "tfsubnet2" {
  name                = "subnet2-internal-frontend"
  resource_group_name = "${data.azurerm_resource_group.ExistingNetworkRG.name}"
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefix       = "10.1.2.0/24"
}

# Create virtual network - DMZ Subnet3
resource "azurerm_subnet" "tfsubnet3" {
  name                = "subnet3-internal-backend"
  resource_group_name = "${data.azurerm_resource_group.ExistingNetworkRG.name}"
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefix       = "10.1.3.0/24"
}

# Create virtual network - internal Subnet4
resource "azurerm_subnet" "tfsubnet4" {
  name                = "subnet4-internal-backend"
  resource_group_name = "${data.azurerm_resource_group.ExistingNetworkRG.name}"
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefix       = "10.1.4.0/24"
}

# Create virtual network - internal Subnet5
resource "azurerm_subnet" "tfsubnet5" {
  name                = "subnet5-internal-backend"
  resource_group_name = "${data.azurerm_resource_group.ExistingNetworkRG.name}"
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefix       = "10.1.5.0/24"
}
