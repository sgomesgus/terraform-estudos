# Lab 01 - HCL Basics & Recursos Básicos

## 📌 Visão Geral
Neste laboratório, foram explorados os fundamentos da **HCL (HashiCorp Configuration Language)**, a linguagem declarativa utilizada pelo Terraform para definir infraestrutura como código (IaC).

---

## 📖 Conceitos Aprendidos

### 1. Estrutura de um Bloco de Recurso
A sintaxe fundamental para declarar recursos no Terraform segue a estrutura:

```hcl
<BLOCK_TYPE> "<RESOURCE_TYPE>" "<RESOURCE_NAME>" {
  <ARGUMENT> = <VALUE>
}
```

* **`resource`**: Tipo do bloco que define que um recurso de infraestrutura será gerenciado.
* **`local_file`**: Tipo de recurso fornecido pelo provider `local` (indica criação/gestão de arquivo local).
* **`pet`**: Nome identificador local (usado apenas dentro do código Terraform para referências).
* **Argumentos (`filename`, `content`, `file_permission`)**: Propriedades e configurações específicas do recurso.

---

## 💻 Exemplo Prático (`main.tf`)

```hcl
resource "local_file" "pet" {
  filename        = "/home/gus/pets.txt"
  content         = "Nós amamos animais!!!"
  file_permission = "0700"
}
```

### Detalhamento dos Atributos:
* `filename`: Caminho absoluto ou relativo do arquivo a ser criado no disco.
* `content`: Conteúdo textual que será escrito no arquivo.
* `file_permission`: Permissão Unix em formato octal (ex: `0700` dá leitura, escrita e execução apenas para o dono).

---

## 🛠️ Comandos Práticos

1. **Inicializar o Terraform**:
   ```bash
   terraform init
   ```
   Baixa o provider necessário (`hashicorp/local`) e cria o lockfile (`.terraform.lock.hcl`).

2. **Validar sintaxe e formatação**:
   ```bash
   terraform fmt       # Formata o arquivo .tf de acordo com os padrões HCL
   terraform validate  # Valida a sintaxe da configuração
   ```

3. **Planejar e aplicar as mudanças**:
   ```bash
   terraform plan      # Mostra o plano de execução (criação do arquivo)
   terraform apply     # Aplica o plano e cria o recurso
   ```

4. **Destruir o recurso**:
   ```bash
   terraform destroy   # Remove o arquivo criado pelo Terraform
   ```
