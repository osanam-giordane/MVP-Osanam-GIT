# Armazena Secret de arquivo em variável chamada $keyvault
set-variable -name keyvault -value (Get-Content -Path <SECRET_EM_ARQUIVO_TXT_DO_SERVICE_PRINCIPAL>)

# Obtém conexão com Microsoft Azure"     
"Logging in to Azure..."

az login --service-principal --username <ID_SERVICE_PRINCIPAL> --password $keyvault --tenant <TENANT+ID_SERVICE_PRINCIPAL> | ConvertFrom-Json

# Seleciona Subscription onde se encontra o Azure Key Vault
az account set --subscription <SUBSCRIPTION_ID_ONDE_SE_ENCONTRA_KEY_VAULT>

# Armazena Nome do Vault e Secrets
$KeyVault = az keyvault show --name <NOME_KEY_VAULT> --query name -o tsv
$secrets = az keyvault secret list --vault-name <NOME_KEY_VAULT>

# Converte Secrets listadas em arquivo JSON
$expire = $secrets | ConvertFrom-Json

# Armazena data 7 dias
$Date = Get-Date (Get-Date).AddDays(7) -Format yyyyMMdd

# Armazena data atual
$CurrentDate = Get-Date -Format yyyyMMdd

# Setando variável apra criação de objeto customizável
$NearExpirationSecrets = @()

# Armazena url do webhook do canal do Microsoft Teams
$connectorUri = '<link_webhook_criado_teams>'

# Validação de cada secret do Vault se a mesma está com vencimento em no máximo 7 dias 
foreach ($secret in $expire) {
    if ($secret.attributes.expires) {
        $secretExpiration = Get-Date $secret.attributes.expires -Format yyyyMMdd
        # Se vencerá, cria-se objeto customizável e armazena em variável
        if ($secretExpiration -lt $Date -and $secretExpiration -gt $CurrentDate){
            $NearExpirationSecrets += New-Object PSObject -Property @{
                    Name           = $secret.name;
                    Category       = 'SecretNearExpiration';
                    KeyVaultName   = $KeyVault;
                    ExpirationDate = $secret.attributes.expires;
                }
      # Criação de card legado para envio ao canal no Microsoft Teams e converte para JSON
      $JSON = @{
        "@type"    = "MessageCard"
        "@context" = "<http://schema.org/extensions>"
        "title"    = 'Azure Key Vault -Secrets a expirar'
        "text"     = 'Secrets expirando'
        "sections" = @(
          @{
            "activityTitle"    = 'Chave a expirar'
            "activitySubtitle" = 'Secrets - '+$NearExpirationSecrets.Name
            "activityText"     = 'Data de expiracao - '+$NearExpirationSecrets.ExpirationDate
          }
        )
      } | ConvertTo-JSON
              
      # Armazena em variável dados para envio de Webhook Microsoft Teams
      $Params = @{
        "URI" = $connectorUri
        "Method" = 'POST'
        "Body" = $JSON
        "ContentType" = 'application/json'
      }
      
      # Envio de Webhook via método REST
      Invoke-RestMethod @Params
      
      # Informa em linha de comando as chaves a expirar
      Write-Host "Secrets que irão expirar em até 7 dias ou menos"
              
      $NearExpirationSecrets
      
      # Limpeza de variáveis para condicional IF
      Clear-Variable -Name "NearExpirationSecrets"
      Clear-Variable -Name "Params"
      Clear-Variable -Name "JSON"           
    }
}
}





