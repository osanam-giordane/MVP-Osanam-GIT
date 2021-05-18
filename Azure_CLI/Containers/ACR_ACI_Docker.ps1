###################################################
### Trabalhando com git em repositórios remotos ###
###################################################

# Clonando repositório exemplo
git clone https://github.com/Azure-Sample/aci-helloworld.git

####################################################
### Contruindo imagem local e rodando localmente ###
####################################################

# Build da aplicação em Dockerfile
docker build ./aci-helloworld -t aci-tutorial-app

# Listando imagens locais
docker images

# Rodando container localmente para validação
docker run -d -p 8080:80 aci-tutorial-app

##########################################################
### Acessando Azure e Criando Azure Container Registry ###
##########################################################

# Login Azure
az login

# Indica Subscription a ser usada
az account set -s <subscription_id>

# Criação de Azure Container Registry
az acr create --resource-group <resourcegroupname> --name <acrname> --sku <tipoSKU>

################################################
### Trabalhando com Azure Container Registry ###
################################################

# Login Azure Container Registry
az acr login -name <acrname>

# Show FQDN Azure Container Registry
az acr show --name <acrname> --query <loginserver> --output table

# Lista imagens locais e efetua tageamento de imagem para envio ao registry
docker images
docker tag aci-tutorial-app <acrname>.azurecr.io/<nomeimagem>:<tag>

# Lista imagem tageada e efetua o envio ao registry
docker images
docker push <acrname>.azurecr.io/<nomeimagem>:<tag>

# Lista imagens armazenadas no registry
az acr repository list --name <acrname> --output table

# Ver tags da imagem no registry
az acr repository show-tags --name <acrname> --repository <repositoryname> --output table

######################################################################################
### Trabalhando com Azure Container Instancer integrado ao Azure Contaner Registry ###
######################################################################################

# Deploy container no Azure Container Instance
Az container create --resource-group <resourcegroupname> --name <containername> --image <acrname>.azurecr.io/<nomeimagem>:<tag> --cpu 1 --memory 1 --registry-login-server <acrLoginServer> --registry-username <acrusername> --registry-password <acrpassword> --dns-name-label <aciDNsLabel> --ports <portaexposta_ex_80>

# Visualizar estado do container
az container show --resource-group <resourcegroupname> --name <nomecontainerimage> --query instanceView.state

# Visualizar FQDN do container
az container show --resource-group <resourcegroupname> --name <nomecontainer> --query ipAddress.fqdn

# Visualizar logs do container
az container logs --resource-group <resourcegroupname> --name <nomecontainer>