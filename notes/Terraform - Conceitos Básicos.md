## Comandos
### init
Inicializa o projeto Terraform e baixa os providers e módulos necessários.
### plan
Gera um plano de execução mostrando quais mudanças serão realizadas para atingir o estado desejado.
### apply
Aplica as mudanças definidas no plano e cria, altera ou remove recursos conforme necessário.
### destroy
Remove todos os recursos gerenciados pela configuração Terraform.
### validate
Verifica se a sintaxe e a estrutura dos arquivos Terraform estão corretas.
### fmt
Formata os arquivos `.tf` seguindo o padrão oficial do Terraform.
## Arquivos
### .tf
Arquivos que contêm a infraestrutura declarada em código.
### terraform.tfstate
Armazena o estado atual da infraestrutura, mantendo o mapeamento entre os recursos reais e as configurações declaradas.
### terraform.tfvars
Arquivo utilizado para definir valores de variáveis.
## Conceitos
### Provider
Plugin responsável por interagir com uma plataforma ou serviço (AWS, Azure, GCP, Kubernetes, etc.).
### Resource
Representa um objeto da infraestrutura que será criado ou gerenciado pelo Terraform.
### Variable
Permite parametrizar configurações para reutilização e flexibilidade.
### Output
Exibe informações após a execução do Terraform, como IPs ou IDs de recursos.
### State
Representação do ambiente real conhecida pelo Terraform. É utilizada para identificar diferenças entre o estado atual e o desejado.
## Fluxo Básico
1. Escrever a configuração (`.tf`)
2. Executar `terraform init`
3. Executar `terraform plan`
4. Executar `terraform apply`
5. Verificar os recursos criados
6. Quando necessário, executar `terraform destroy`