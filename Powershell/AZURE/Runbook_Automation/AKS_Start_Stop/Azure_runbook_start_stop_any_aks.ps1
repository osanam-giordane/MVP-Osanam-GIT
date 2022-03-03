# Recebe parâmetros Resource Group, VM(Recurso) e status (start|stop)
param (
	[Parameter(Mandatory)] [string] $acao,
    [Parameter(Mandatory)] [string] $nametag,
    [Parameter(Mandatory)] [string] $valuetag
    )

# Garante que você não herde um AzContext em seu runbook
Disable-AzContextAutosave -Scope Process

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

# Conecte-se ao Azure com system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# define e armazena o contexto
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

if ($acao -eq "start"){
    #Start-AKS
    #------------------------------------------------------------------------------------------------------------------------------
    # Varre todos resource groups em busca dos AKS´s de acordo com TAG indicada e Inicia os AKS´s conforme parâmetros repassados
	
    # Armazena Clusters em variável de acordo com tags passada
    $AKSName = Get-AzAksCluster | Where-Object {$_.Tags["$nametag"] -like "$valuetag"} | Select-Object -ExpandProperty Name
    
    # Armazena Resource Groups em variável
    $ResourceGroupName = Get-AzResourceGroup | Select-Object -ExpandProperty ResourceGroupName

    # Loop para efetuar start do cluster
    for ($rg = 0; $rg -lt $ResourceGroupName.Count; $rg++) {

        foreach ($aks in $AKSName) { 
			try { 
            write-output "Efetuando tentativa de start do cluster $aks em Resource Group $($ResourceGroupName[$rg])"
            Start-AzAksCluster -Name $aks -ResourceGroupName $ResourceGroupName[$rg] -ErrorAction Ignore
			write-output "CLUSTER INICIADO"
			} Catch {
				write-output "Cluster não encontrado"
			}          
        }
    }
}
elseif ($acao -eq "stop") {
    #Stop-VM
    #------------------------------------------------------------------------------------------------------------------------------
    # # Varre todos resource groups em busca dos AKS´s de acordo com TAG indicada e efetua parada dos AKS´s conforme parâmetros repassados

    # Armazena Clusters em variável de acordo com tags passada
    $AKSName = Get-AzAksCluster | Where-Object {$_.Tags["$nametag"] -like "$valuetag"} | Select-Object -ExpandProperty Name

    # Armazena Resource Groups em variável
    $ResourceGroupName = Get-AzResourceGroup | Select-Object -ExpandProperty ResourceGroupName

    # Loop para efetuar stop do cluster
    for ($rg = 0; $rg -lt $ResourceGroupName.Count; $rg++) {

        foreach ($aks in $AKSName) {
			try { 
            write-output "Efetuando tentativa de stop do cluster $aks em Resource Group $($ResourceGroupName[$rg])" 
		    Stop-AzAksCluster -Name $aks -ResourceGroupName $ResourceGroupName[$rg] -ErrorAction Ignore
			write-output "CLUSTER DESLIGADO"
			} Catch {
				write-output "Cluster não encontrado"
			}          
        }
    }
    #------------------------------------------------------------------------------------------------------------------------------
} else {
    write-output "Opção inválida - Campo Ação deve conter start ou stop"
}