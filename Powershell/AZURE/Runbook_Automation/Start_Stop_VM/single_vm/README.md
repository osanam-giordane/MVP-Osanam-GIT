# [Start-Stop] Runbook Azure Automaton - VM única

Para que possamos iniciar e parar uma VM precisamos efetuar os seguintes passos:

1. Criar uma conta no Azure Automation
2. Criar um Runbook Powershell
3. Editar o Runbook Powershell e colar o script
4. Ao criar/rodar o script, devemos passar os seguintes parâmetros:
*    RESOURCEGROUPNAME
    <BR>Nome do Grupo de Recursos onde se encontram as VM´s
    <BR>

*    RESOURCENAME
     <BR>Nome da VM que será iniciada/desligada

*    ACAO
    <BR>Insira opção de Iniciar VM´s (***start***) ou de Desligar VM´s (***stop***)

![alt text](https://github.com/osanam-giordane/MVP-Osanam-GIT/blob/master/Powershell/AZURE/Runbook_Automation/Start_Stop_VM/multiple_vms/images/campos.png?raw=true)