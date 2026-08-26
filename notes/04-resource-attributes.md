# Lab 04 - Atributos de Recursos & Dependência Implícita

## 📌 Visão Geral
Neste laboratório, foi explorado como referenciar atributos gerados por um recurso dentro de outro recurso, estabelecendo automaticamente uma **dependência implícita (Implicit Dependency)**.

---

## 📖 Conceitos Aprendidos

### 1. Referência Cruzada de Atributos
No Terraform, recursos exportam atributos após serem planejados ou criados. A sintaxe de referência é:

```hcl
<TIPO_RECURSO>.<NOME_RECURSO>.<ATRIBUTO>
```

Exemplo: `random_pet.meu_pet.id` acessa o atributo `id` gerado pelo recurso `random_pet`.

---

### 2. Dependência Implícita (Implicit Dependency)
* Quando o `local_file.arquivo_pet` referencia `${random_pet.meu_pet.id}`, o Terraform entende automaticamente que:
  1. Primeiro deve criar o recurso `random_pet.meu_pet`.
  2. Em seguida, com o valor do `id` gerado, criar o `local_file.arquivo_pet`.
* O Terraform constrói internamente um grafo acíclico direcionado (**DAG - Directed Acyclic Graph**) para ordenar a execução de forma paralela e segura.

---

## 💻 Exemplo Prático (`main.tf`)

```hcl
resource "random_pet" "meu_pet" {
  length = 1
}

resource "local_file" "arquivo_pet" {
  filename = "/home/gus/pet_terraform.txt"
  content  = "Meu pet gerado pelo terraform é ${random_pet.meu_pet.id}"
}
```

### Ordem de Execução no `terraform apply`:
1. `random_pet.meu_pet` é criado primeiro e gera um ID randômico (ex: `"mutt"`).
2. `local_file.arquivo_pet` é criado depois, inserindo o ID no conteúdo do arquivo `/home/gus/pet_terraform.txt`.
