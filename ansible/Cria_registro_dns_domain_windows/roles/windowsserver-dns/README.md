# TL;DR

### Exemplo de chamada do playbook<br></br>

```
ansible-playbook --vault-password-file=<caminho_do_arquivo_da_chave_criptografada> -e "name=<alias_do_registro> type=<CNAME_ou_HostA_HostAAAA_PTR> acao=<CRIAR_ou_REMOVER> value=<Valor_do_CNAME_ou_HostA_HostAAAA_PTR> zone=<zona_de_domínio> <playbook_referência> -i <arquivo_hosts>
```

#### Criação/Atualização/Remoção de registros DNS

Para a estrutura de DNS, criamos toda a estrutura de scripts IaC via Ansible, estruturado da seguinte forma:

##### ansible/playbooks/

###### ├── create_windows_dns.yml

* Arquivo principal que efetua as chamadas da role windowsserver-dns.

##### ansible/roles/windowsserver-dns/

###### ├── tasks

######    ├── main.yml

* Tasks relacionadas a criação e remoção de registros e seus campos com as variáveis para recebimento dos dados. ``

###### └── vars

######     ├── main.yml

* Arquivo contendo as variáveis passadas para conexão via protocolo WINRM na porta HTTPS 5986 e variáveis de chaves de acesso para conexão.

######     └── vault.yml

* Você pode criar um arquivo contendo a chave do usuário de serviço que efetua conexão no DNS para criação de registros e passar o mesmo para conexão.
Utilize o link abaixo como referência de utilização do Ansible Vault:
https://docs.ansible.com/ansible/latest/user_guide/vault.html

> Criação | Atualização | Remoção de registros DNS


###### Campos para criação | atualização de registro DNS

* Name - Alias do registro, não é necessária a inclusão de FQDN completo.
* Type - Informe  CNAME (FQDN), Hosta A ou AAAA (Endereço IP) ou PTR (Ponteiro) 
* Value - FQDN de Origem (CNAME) ou Endereço IP de Origem (Host A) ou Ponteiro PTR
* Zone - Informe a zona de domínio (Exemplo **osanam.dev** ou **osanam.com**)
* Criar ou Alterar | Remover - Informe a opção de Criar ou Remover



###### Campos para remoção de registro DNS

* Será necessário preencher os campos **Name**, **Type**, **Zone** e opção de **Remover**





Obs.: Inclua o arquivo hosts com o servidor que será utilizado para conexão (Servidor ADDS).

Desta forma temos um modelo automatizado de criação, atualização ou remoção de registros DNS.