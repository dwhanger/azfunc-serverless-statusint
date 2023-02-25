Status Int Stack Set Up
=======================

Log in to Azure using the CLI:

``` shell
az login
```

Get the Subscription ID and Storage Account Name from `backend.tf`.  Or, if this is a new subscription, do the following to create a new service principal:

``` shell
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"

Your appId, password, sp_name, and tenant are returned. Make a note of the appId and password.
```

Finally, it's possible to test these values work as expected by first logging in:

``` shell
az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID
```

If this is a new subscription, then you will need to create the resource group and storage account where Terraform will store its state files

``` shell
az group create --name $RESOURCE_GROUP_NAME --location $AZURE_REGION_LOCATION_NAME

az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $AZURE_REGION_LOCATION_NAME --sku Standard_LRS
```

Create a Blob storage container for the state file for your stack.

``` shell
az storage container create --name $STACK_NAME \
    --auth-mode login \
    --account-name $STORAGE_ACCOUNT_NAME \
    --subscription $SUBSCRIPTION_ID
```

Point the Azure CLI to the correct subscription for your stack.
Ex.: MUSE1-NP02-ENG-PROD for US East Prod, MUSE1-NN01-ENG for Non Prod/Staging, etc..

``` shell
az account set --subscription $SUBSCRIPTION_NAME
```

Set up Terraform. It's going to ask for:

* The name of container for you state file.
* A key, that is a file name, for your state file.

For the container name use the one you just created. for the state file name use your stack name followed by `.tf`.

``` shell
terraform init
```

Verify which variables from `variables.tf` you need to adjust.

Check that Terraform will create the resources you need.

``` shell
terraform plan
```

If everything looks good create the resources.

``` shell
terraform apply
```

Get the name of Resource Group, CosmosDB Account you just created.

Create CosmosDB Database.

``` shell
az cosmosdb database create --db-name statusintdashcosmosdb \
    --resource-group $RESOURCE_GROUP \
    --name $COSMOSDB_ACCOUNT
```

Create the CosmosDB Collections.

``` shell
for collection in EndPointStatusCheck EndPointStatusCheckHistory EndPointStatusConfig; do
    az cosmosdb collection create \
        --resource-group $RESOURCE_GROUP \
        --collection-name $collection \
        --name $COSMOSDB_ACCOUNT \
        --db-name statusintdashcosmosdb \
        --partition-key-path /id \
        --throughput 400
done

az cosmosdb collection create \
    --resource-group $RESOURCE_GROUP \
    --collection-name GeneralConfig \
    --name $COSMOSDB_ACCOUNT \
    --db-name statusintdashcosmosdb \
    --partition-key-path /Type \
    --throughput 400
```

Upload `int/db/EndPointStatusConfigDataLoad.json` to `EndPointStatusConfig`.
Upload `int/db/GeneralConfig.json` to `GeneralConfig`.

Create a SendGrid account via the Azure portal, click the management link and create a new API key.

In the static website storage account, enable `Static website`. Set `Index document name` to `index.html`. Save the URL for the site.

Edit the `status-int-master` and/or `status-int-development` Release Pipeline in Azure DevOps. Add a new stage for you stack.

Create a new Variable Group for your stack in Azure DevOps by copying an existing group. Copy variables from function app application settings.

Deploy a release to the stack.

Create an event subscription for the `EndPointStatusChecker` function by selecting the function and selecting the 'Add Event Grid Subscription' link and configure it with EventGridTopic, all events, and the Event Grid Schema. Use Prefix Filter `http`.

Create an event subscription for the `EndPointCheckerTypeAlertSite` function by selecting the function and selecting the 'Add Event Grid Subscription' link and configure it with EventGridTopic, all events, and the Event Grid Schema. Use Prefix Filter `alertsite`.


Lastly, create a VNET integration following the Azure documentation https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet
	- Set the following app settings for the DNS (after vnet integration, otherwise it will screw up everything connectivity wise)
	    WEBSITE_DNS_ALT_SERVER         = "10.142.1.4"
	    WEBSITE_DNS_SERVER             = "10.82.1.4"
	- add each services to the vnet
	- do the whitelisting of the EventGrid IP's (3 of them)
	- do the whitelisting of the VSTS build machine agents
		Example:
				100			storage acccount		<ip address, 13.90.143.69/32>		allow
				110			admin vpn				155.64.38.0/24						allow
				120			tyeesoftware india cidr	199.85.125.0/24						allow
				200			admin vpn chennai		155.64.138.0/24						allow
				300 		vsts build agents		10.0.0.0/8							allow
				400			vsts smoke test			40.112.194.88/32					allow
				500			eventgrid ip1			(useast)52.224.182.0/24				allow
				510			eventgrid ip2			(useast)13.82.85.0/24				allow
				520			eventgrid ip3			(useast)52.191.209.0/24				allow

