# Lab 03 - Variáveis de Entrada & Arquivos `.tfvars`

## 📌 Visão Geral
Neste laboratório, foram explorados os conceitos de **Input Variables (Variáveis de Entrada)**, permitindo parametrizar o código Terraform, torná-lo reutilizável e desacoplar dados dinâmicos da lógica da infraestrutura.

---

## 📖 Conceitos Aprendidos

### 1. Declaração de Variáveis (`variables.tf`)
Variáveis são declaradas usando o bloco `variable`:

```hcl
variable "filename" {
  description = "Nome do arquivo a ser criado"
  type        = string
}

variable "pet_name" {
  description = "Nome do pet"
  type        = string
}

variable "pet_type" {
  description = "Tipo do pet"
  type        = string
}
```

* **`description`**: Documentação explicativa do propósito da variável.
* **`type`**: Tipo de dado esperado (`string`, `number`, `bool`, `list`, `map`, `object`, etc.).
* **`default`** *(opcional)*: Valor padrão caso nenhum valor seja informado.

---

### 2. Uso de Variáveis no Código (`main.tf`)
Para referenciar o valor de uma variável declarada, utiliza-se a sintaxe `var.<NOME_VARIAVEL>` ou interpolação de strings `${var.<NOME_VARIAVEL>}`:

```hcl
resource "local_file" "pet_file" {
  filename = var.filename
  content  = "Meu pet se chama ${var.pet_name} e é um ${var.pet_type}."
}
```

---

### 3. Atribuição de Valores (`terraform.tfvars`)
O Terraform carrega automaticamente os arquivos chamados `terraform.tfvars` ou `*.auto.tfvars`:

```hcl
filename = "/home/gus/meu_pet.txt"
pet_name = "Max"
pet_type = "Cachorro"
```

---

## ⚡ Formas de Passar Variáveis no Terraform (Ordem de Precedência)

O Terraform resolve valores de variáveis na seguinte ordem (da menor para a maior precedência):

1. **Valores `default`** no bloco `variable`
2. **Variáveis de Ambiente** (`export TF_VAR_pet_name="Max"`)
3. **Arquivo `terraform.tfvars`**
4. **Arquivo `terraform.tfvars.json`**
5. **Arquivos `*.auto.tfvars`** (em ordem alfabética)
6. **Linha de Comando via flags** (`terraform apply -var="pet_name=Rex" -var-file="custom.tfvars"`)
