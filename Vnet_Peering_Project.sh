
az group create -n Vnet_Project -l eastus

az network vnet create -g Vnet_Project -n "IT_department" --address-prefix 192.168.0.0/16 \
--subnet-name Subnet1  --subnet-prefix 192.168.1.0/24

az network vnet subnet create -g Vnet_Project --vnet-name "IT_department" --name Subnet2 \
--address-prefix 192.168.2.0/24

az network vnet create -g Vnet_Project -n "Financial_department" \
--address-prefix 10.10.0.0/16 \ 
--subnet-name Sub1  --subnet-pefix 10.10.1.0/24


az vm create -l eastus \
--image MicrosoftWindowsServer:WindowsServer:2019-datacenter-gensecond:latest \
-g Vnet_Project -n VM_N1 \
--authentication-type password  --admin-username AZURE \
--admin-password "AzureMaroc@2024" --vnet-name "IT_department" --subnet Subnet1  


az vm create -l eastus \
--image MicrosoftWindowsServer:WindowsServer:2019-datacenter-gensecond:latest \
-g Vnet_Project -n VM_N2 \
--authentication-type password  --admin-username AZURE \
--admin-password "AzureMaroc@2024" --vnet-name "IT_department" --subnet Subnet2


az vm create -l eastus \
--image MicrosoftWindowsServer:WindowsServer:2019-datacenter-gensecond:latest \
-g Vnet_Project -n VM_N3 \
--authentication-type password  --admin-username AZURE \
--admin-password "AzureMaroc@2024" --vnet-name "Financial_department" --subnet Sub1



az network vnet peering create \
  --name IT-to-Financial \
  --resource-group Vnet_Project \
  --vnet-name "IT_department" \
  --remote-vnet "$(az network vnet show --name "Financial_department" --resource-group Vnet_Project --query id -o tsv)" \
  --allow-vnet-access



az network vnet peering create \
  --name Financial-to-IT \
  --resource-group Vnet_Project \
  --vnet-name "Financial_department" \
  --remote-vnet "$(az network vnet show --name "IT_department" --resource-group Vnet_Project --query id -o tsv)" \
  --allow-vnet-access
#make sure that the firewall is disabled on the two vm !!!!!!
