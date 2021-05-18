# Recebe parâmetros Resource Group, VM(Recurso) e status (start|stop)
param ([Parameter(Mandatory)] [string] $ResouceGroupName,
    [Parameter(Mandatory)] [string[]] $ResourceName,
    [Parameter(Mandatory)] [string] $acao)

if ($acao -eq "start"){
    #Start-VM
    $connectionName = "AzureRunAsConnection"
    try
    {
        # Obtém conexão com usuário automation "AzureRunAsConnection"
        $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

        "Logging in to Azure..."
        Add-AzureRmAccount `
            -ServicePrincipal `
            -TenantId $servicePrincipalConnection.TenantId `
            -ApplicationId $servicePrincipalConnection.ApplicationId `
            -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
    # Inicia VM conforme parâmetros repassados
    foreach ($vm in $ResourceName)
    {
        Start-AzureRmVM -Name $vm -ResourceGroupName $ResouceGroupName
    }
    #------------------------------------------------------------------------------------------------------------------------------
}
elseif ($acao -eq "stop") {
    #Stop-VM
    #------------------------------------------------------------------------------------------------------------------------------
    $connectionName = "AzureRunAsConnection"
    try
    {
        # Obtém conexão com usuário automation "AzureRunAsConnection"
        $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

        "Logging in to Azure..."
        Add-AzureRmAccount `
            -ServicePrincipal `
            -TenantId $servicePrincipalConnection.TenantId `
            -ApplicationId $servicePrincipalConnection.ApplicationId `
            -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
    # Parando VM conforme parâmetros repassados
    foreach ($vm in $ResourceName)
    {
        stop-azurermvm -Name $vm -ResourceGroupName $ResouceGroupName -force
    }
    #------------------------------------------------------------------------------------------------------------------------------
} else {
    write-output "Opção inválida - Campo Ação deve conter start ou stop"
}