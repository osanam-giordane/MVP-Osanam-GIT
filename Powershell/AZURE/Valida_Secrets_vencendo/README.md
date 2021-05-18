# TL;DR

### Pré requisito:

- AZ CLI instalado
- Chave de conexão ao Service Principal armazenado em arquivo localmente
- Webhook criado para alerta dentro de canal em grupo no Microsoft Teams

Este script varrerá o seu Azure Key Vault em buscas de duas secrets e validará se as mesmas estão vencendo com data menor ou igual a 7 dias da data atual.

Para alterar a quantidade de dias, altere a linha **20** para o tempo maior ou menor que **7** de acordo com sua necessidade.

Assim que criar o webhook, altere a linha **29** incluindo o link do Webhook.

Segue exemplo de card que aparcerá no Teams:

![Imagem de card em canal no Teams quando é alertado](https://osanamgiordane.com.br/wp-content/uploads/2021/05/secret_vencimento.png)

Para aletração dos textos na imagem, mude dentro da variável na linha **44 a 53** conforme os textos do card.

Desta form você terá uma automação para validar suas secrets enquanto não há opção nativa como temos em certificados dentro do próprio Azure Key Vault e sem a necessidade de utiliza um Logic Apps.

Segue exemplo de ativação para certificados de forma nativa:

![](https://osanamgiordane.com.br/wp-content/uploads/2021/05/certificate_contact.png)

Links de referência:

* Cards legados para webhooks Teams: [Clique aqui](https://docs.microsoft.com/pt-br/outlook/actionable-messages/message-card-reference?WT.mc_id=AZ-MVP-5001893)
* Instação AZ CLI: [Clique aqui](https://docs.microsoft.com/pt-br/cli/azure/install-azure-?WT.mc_id=AZ-MVP-5001893)
* Aprendizado Service Principal Azure (Acesso as API´s do Azure): [Clique aqui](https://youtu.be/vF-Z3urjbcw)
* Criando Webhook no Teams: [Postar solicitações externas no Teams com Webhook](https://docs.microsoft.com/pt-br/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook#:~:text=Incoming%20webhooks%20are%20special%20type,typically%20in%20a%20card%20format.?WT.mc_id=AZ-MVP-5001893)

Abraços!