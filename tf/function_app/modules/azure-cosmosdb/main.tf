#
# Create our CosmosDB, collections/containers, and load them with seed data if applicable...
#
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${var.name}-${var.platform}-${var.region}-${var.environment}-cosmosdb"
  location            = var.resgroup_main_location
  resource_group_name = var.resgroup_main_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = false

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    failover_priority = 0
    location          = var.resgroup_main_location
  }

  is_virtual_network_filter_enabled = true

#
# per instructions here: https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall#allow-requests-from-the-azure-portal
#
# ...enable portal access for <my ip address>, and regions other than USGov and China...
# ...not enabling 0.0.0.0 which would allow connections from within public Azure datacenters....(too wide of access)
#
  ip_range_filter = "${var.ip_to_allow}/32,104.42.195.92/32,40.76.54.131/32,52.176.6.30/32,52.169.50.45/32,52.187.184.26/32" 

  virtual_network_rule {
    id = var.subnet3_id
  }

  tags = var.tags
}

#
# Create the database, collections, and load the collection with seed data....
#
# az cosmosdb database create --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_cosmosdb_account.cosmosdb.name} --db-name statusintdashcosmosdb
resource "azurerm_cosmosdb_sql_database" "sqldb" {
  name                = "statusintdashcosmosdb"
  resource_group_name = var.resgroup_main_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  throughput          = 400
}

# az cosmosdb collection create --resource-group ${azurerm_resource_group.main.name} --collection-name EndPointStatusCheck --name ${azurerm_cosmosdb_account.cosmosdb.name} --db-name statusintdashcosmosdb --partition-key-path /id --throughput 400"
resource "azurerm_cosmosdb_sql_container" "sql_cont_EndPointStatusCheck" {
  name                = "EndPointStatusCheck"
  resource_group_name = var.resgroup_main_name
  account_name        = azurerm_cosmosdb_sql_database.sqldb.account_name
  database_name       = azurerm_cosmosdb_sql_database.sqldb.name
  partition_key_path    = "/id"
  partition_key_version = 1
  throughput            = 400
/*
  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }
*/
  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

# az cosmosdb collection create --resource-group ${azurerm_resource_group.main.name} --collection-name EndPointStatusCheckHistory --name ${azurerm_cosmosdb_account.cosmosdb.name} --db-name statusintdashcosmosdb --partition-key-path /id --throughput 400
resource "azurerm_cosmosdb_sql_container" "sql_cont_EndPointStatusCheckHistory" {
  name                = "EndPointStatusCheckHistory"
  resource_group_name = var.resgroup_main_name
  account_name        = azurerm_cosmosdb_sql_database.sqldb.account_name
  database_name       = azurerm_cosmosdb_sql_database.sqldb.name
  partition_key_path    = "/id"
  partition_key_version = 1
  throughput            = 400
  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

# az cosmosdb collection create --resource-group ${azurerm_resource_group.main.name} --collection-name EndPointStatusConfig --name ${azurerm_cosmosdb_account.cosmosdb.name} --db-name statusintdashcosmosdb --partition-key-path /id --throughput 400
resource "azurerm_cosmosdb_sql_container" "sql_cont_EndPointStatusConfig" {
  name                = "EndPointStatusConfig"
  resource_group_name = var.resgroup_main_name
  account_name        = azurerm_cosmosdb_sql_database.sqldb.account_name
  database_name       = azurerm_cosmosdb_sql_database.sqldb.name
  partition_key_path    = "/id"
  partition_key_version = 1
  throughput            = 400
  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

# az cosmosdb collection create --resource-group ${azurerm_resource_group.main.name} --collection-name GeneralConfig --name ${azurerm_cosmosdb_account.cosmosdb.name} --db-name statusintdashcosmosdb --partition-key-path /Type --throughput 400
resource "azurerm_cosmosdb_sql_container" "sql_cont_GeneralConfig" {
  name                = "GeneralConfig"
  resource_group_name = var.resgroup_main_name
  account_name        = azurerm_cosmosdb_sql_database.sqldb.account_name
  database_name       = azurerm_cosmosdb_sql_database.sqldb.name
  partition_key_path    = "/Type"
  partition_key_version = 1
  throughput            = 400
  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

#
# Load seed data...
#
locals {
  str_empty = ""
}

locals {
  str_doublequote = "__quote__"
}

locals {
  str_backslash = "\\"
}

locals {
  str_newline = "\n"
}

locals {
  EndPointStatusConfig_data_load = <<EOF
"${local.str_doublequote}dt.exe /ErrorDetails:All /s:JsonFile /s.Files:../../db/EndPointStatusConfigDataLoadPROD.json /t:DocumentDB /t.ConnectionString:'AccountEndpoint=${azurerm_cosmosdb_account.cosmosdb.endpoint};AccountKey=${azurerm_cosmosdb_account.cosmosdb.primary_key};Database=statusintdashcosmosdb' /t.ConnectionMode:Gateway /t.CollectionThroughput:400 /t.IdField:id /t.DisableIdGeneration /t.UpdateExisting /t.Collection:EndPointStatusConfig /t.PartitionKey:/id${local.str_doublequote}"
EOF

}

#
# Load seed data into the EndPointStatusConfig collection...using the dt.exe utility...
#
resource "null_resource" "update_the_seed_data_in_EndPointStatusConfig_collection" {
  depends_on = [azurerm_cosmosdb_sql_container.sql_cont_EndPointStatusConfig]

  provisioner "local-exec" {
    working_dir = "${path.module}\\..\\.."
    command = "echo Invoke-Expression ${replace(
      local.EndPointStatusConfig_data_load,
      local.str_newline,
      local.str_empty,
    )} > update_seed_data_in_EndPointStatusConfig.txt"
  }

  #
  # Do string replacement on __quote__ and replace with " from a powershell script...
  #
  provisioner "local-exec" {
    #
    # Can't do the following....and the escape sequence in the single quotes of \"" is the only thing which works from the powershell command line...
    #   command = "powershell -Command \"(gc ${path.module}\\update_seed_data_in_EndPointStatusConfig.txt) -replace '__quote__', '\""' | Out-File -encoding ASCII ${path.module}\\update_seed_data_in_EndPointStatusConfig.bat\""
    #
    # ....instead shell out and execute the batch file...
    #
    working_dir = "${path.module}\\..\\.."
    command = "do_powershell_search_and_replace_for_EndPointStatusConfig.bat"
  }

  #
  # Load the seed data file into EndPointStatusConfig collection...
  #
  # ....and set the execution policy for powershell to unrestricted: "Set-ExecutionPolicy -ExecutionPolicy Unrestricted" as admin from powershell...
  #
  provisioner "local-exec" {
    working_dir = "${path.module}\\..\\.."
    command     = "update_seed_data_in_EndPointStatusConfig.ps1"
    interpreter = ["PowerShell", "-Command"]
    on_failure  = continue
  }
}

locals {
  GeneralConfig_data_load = <<EOF
"${local.str_doublequote}dt.exe /ErrorDetails:All /s:JsonFile /s.Files:../../db/GeneralConfig.json /t:DocumentDB /t.ConnectionString:'AccountEndpoint=${azurerm_cosmosdb_account.cosmosdb.endpoint};AccountKey=${azurerm_cosmosdb_account.cosmosdb.primary_key};Database=statusintdashcosmosdb' /t.ConnectionMode:Gateway /t.CollectionThroughput:400 /t.IdField:id /t.DisableIdGeneration /t.UpdateExisting /t.Collection:GeneralConfig /t.PartitionKey:/Type${local.str_doublequote}"
EOF

}

#
# Load seed data into the GeneralConfig collection...using the dt.exe utility on github...
#
resource "null_resource" "update_the_seed_data_in_GeneralConfig_collection" {
  depends_on = [null_resource.update_the_seed_data_in_EndPointStatusConfig_collection]

  provisioner "local-exec" {
    working_dir = "${path.module}\\..\\.."
    command = "echo Invoke-Expression ${replace(
      local.GeneralConfig_data_load,
      local.str_newline,
      local.str_empty,
    )} > update_seed_data_in_GeneralConfig.txt"
  }

  #
  # Do string replacement on __quote__ and replace with " from a powershell script...
  #
  provisioner "local-exec" {
    #
    # Can't do the following....and the escape sequence in the single quotes of \"" is the only thing which works from the powershell command line...
    #   command = "powershell -Command \"(gc ${path.module}\\update_seed_data_in_GeneralConfig.txt) -replace '__quote__', '\""' | Out-File -encoding ASCII ${path.module}\\update_seed_data_in_GeneralConfig.bat\""
    #
    # ....instead shell out and execute the batch file...
    #
    working_dir = "${path.module}\\..\\.."
    command = "do_powershell_search_and_replace_for_GeneralConfig.bat"
  }

  #
  # Load the seed data file into GeneralConfig collection...
  #
  # ....and set the execution policy for powershell to unrestricted: "Set-ExecutionPolicy -ExecutionPolicy Unrestricted" as admin from powershell...
  #
  provisioner "local-exec" {
    working_dir = "${path.module}\\..\\.."
    command     = "update_seed_data_in_GeneralConfig.ps1"
    interpreter = ["PowerShell", "-Command"]
    on_failure  = continue
  }
}

