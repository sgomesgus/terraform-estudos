# Lab 02 - Providers & Múltiplos Recursos

## 📌 Visão Geral
Neste laboratório, foi explorado o conceito de **Providers** no Terraform e como gerenciar múltiplos recursos de diferentes provedores em um único arquivo de configuração.

---

## 📖 Conceitos Aprendidos

### 1. O que são Providers?
* São plugins que permitem ao Terraform interagir com APIs de nuvens (AWS, GCP, Azure), serviços SaaS ou utilitários locais (como sistemas de arquivos ou geradores de strings randômicas).
* São baixados automaticamente pelo Terraform no momento do comando `terraform init`.

### 2. Provider `local` vs Provider `random`
* **`local`**: Provider utilitário para interagir com o sistema de arquivos local (ex: criar arquivos com `local_file`).
* **`random`**: Provider utilitário para gerar identificadores aleatórios, senhas, pets, etc. (ex: `random_pet`).

---

## 💻 Exemplo Prático (`main.tf`)

```hcl
resource "local_file" "pet" {
  filename        = "/home/gus/pets.txt"
  content         = "Nós amamos animais!!!"
  file_permission = "0700"
}

resource "random_pet" "my-pet" {
  prefix    = "Sra"
  separator = ". "
  length    = "1"
}
```

### Detalhamento dos Recursos:
* **`local_file.pet`**: Cria um arquivo de texto local com permissões restritas.
* **`random_pet.my-pet`**: Gera um nome randômico de animal com:
  * `prefix`: Prefixo customizado anexado ao nome gerado (`"Sra"`).
  * `separator`: Separador entre o prefixo e o nome (`". "`).
  * `length`: Quantidade de palavras randômicas geradas (`"1"`).

---

## 🔄 Arquivo de Bloqueio (`.terraform.lock.hcl`)
* Registra as versões exatas e os hashes de integridade dos providers baixados.
* Garante que execuções futuras em qualquer máquina utilizem exatamente as mesmas versões de plugins.
