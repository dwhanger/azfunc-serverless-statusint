locals {
  nsg_temp_name = "${var.name}${var.platform}${var.region}${var.environment}"
  nsg_base_name = lower(replace(local.nsg_temp_name, "/[[:^alnum:]]/", ""))
  nsg_name = "${substr(
    local.nsg_base_name,
    0,
    length(local.nsg_base_name) < 21 ? -1 : 21,
  )}-nsg"
}

resource "azurerm_network_security_group" "nsg" {
#  depends_on = [var.resgroup_main]

  name                = local.nsg_name
  location            = var.resgroup_main_location
  resource_group_name = var.resgroup_main_name

  security_rule {
    name                   = "https"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "443"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name              = "http_Out"
    priority          = 120
    direction         = "Outbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    source_address_prefix      = "*"
    destination_port_range     = "80"
    destination_address_prefix = "*"
  }
  security_rule {
    name              = "https_Out"
    priority          = 130
    direction         = "Outbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = "*"
  }
  security_rule {
    name                   = "everything_else_in"
    priority               = 200
    direction              = "Inbound"
    access                 = "Deny"
    protocol               = "*"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name              = "everything_else_out"
    priority          = 210
    direction         = "Outbound"
    access            = "Deny"
    protocol          = "*"
    source_port_range = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
}

locals {
  vnet_temp_name = "${var.name}${var.platform}${var.region}${var.environment}"
  vnet_base_name = lower(replace(local.vnet_temp_name, "/[[:^alnum:]]/", ""))
  vnet_name = "${substr(
    local.vnet_base_name,
    0,
    length(local.vnet_base_name) < 20 ? -1 : 20,
  )}-vnet"
}

resource "azurerm_subnet" "subnet1" {
  depends_on = [azurerm_virtual_network.vnet]

  name                      = "subnet-web"
  resource_group_name       = var.resgroup_main_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = [var.subnet_address_prefix_web]
  service_endpoints         = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet2" {
  depends_on = [azurerm_virtual_network.vnet]

  name                      = "subnet-app"
  resource_group_name       = var.resgroup_main_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = [var.subnet_address_prefix_app]
  delegation {
    name = "serverFarm_delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "subnet3" {
  depends_on = [azurerm_virtual_network.vnet]

  name                      = "subnet-db"
  resource_group_name       = var.resgroup_main_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = [var.subnet_address_prefix_db]
  service_endpoints         = ["Microsoft.AzureCosmosDB"]
}


resource "azurerm_subnet_network_security_group_association" "nsg_secgroup1" {
  subnet_id                 = "${azurerm_subnet.subnet1.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_subnet_network_security_group_association" "nsg_secgroup2" {
  subnet_id                 = "${azurerm_subnet.subnet2.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_subnet_network_security_group_association" "nsg_secgroup3" {
  subnet_id                 = "${azurerm_subnet.subnet3.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}


resource "azurerm_virtual_network" "vnet" {
  depends_on = [var.resgroup_main_name]

  name                = local.vnet_name
  location            = var.resgroup_main_location
  resource_group_name = var.resgroup_main_name
  address_space       = [var.vnet_address_space]

  tags = var.tags
}
