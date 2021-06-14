# IaC exemplo de implantação Azure utilizando Hashicorp Terraform

### **Este IaC criará os seguintes recursos:**

* Virtual Network contendo 2 subnets sendo elas:
  * Subnet servers;
  * Subnet Bastion.

* Bastion SaaS para acesso aos servidores linux;
* Criação de três VM´s Linux Ubuntu;
* Network Security group único atachada a subnet servers liberando porta SSH (22);
* Storage account utilizando nome randômico e inclusão de um File Share;
* Todos os recursos dentro de um único Resource Group em East US 2.
---
> Pré requisitos:
- Criação de um Service Principal para conexão com Azure e permissão do mesmo na subscription.
  * Após criação do Service Principal, alterar o arquivo *vars.tf* incluindo as seguintes informações:
    * Subscription ID
    * Client ID
    * Client Secret
    * Tenant ID
---
> Observação:
- Faça um Fork do repositório e utilize a cópia conforme necessitar.
- Altere os nomes dos recursos e inclusão/remoção conforme sua necessidade.
---
> Dúvidas:
- Acesse:
  - Conectando Terraform as API´s do Azure
    * https://youtu.be/vF-Z3urjbcw
  - Create an Azure service principal with the Azure CLI
    * https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?toc=%2Fazure%2Fazure-resource-manager%2Ftoc.json&view=azure-cli-latest?WT.mc_id=AZ-MVP-5001893
  - How to: Use the portal to create an Azure AD application and service principal that can access resources
    *  https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal?WT.mc_id=AZ-MVP-5001893
  - Terraform with Azure
    * https://docs.microsoft.com/en-us/azure/developer/terraform/overview?WT.mc_id=AZ-MVP-5001893
