# Lab 05 - Guia Completo de Meta-Arguments no Terraform

## 📌 Visão Geral
No Terraform, **Meta-Arguments (Meta-Argumentos)** são argumentos especiais reservados pela linguagem HCL que podem ser utilizados dentro de blocos de **`resource`**, **`data`** ou **`module`**. Eles não pertencem a um provedor específico (como AWS, Azure ou Local), mas sim alteram a forma como o próprio Terraform gerencia, cria, escala ou orquestra esses blocos.

---

## 📖 Todos os Meta-Arguments para `resource` e `data`

### 1. `count` (Múltiplas Instâncias por Número)
Cria um número fixo de instâncias do recurso a partir de um valor numérico inteiro.
* **Objeto `count.index`**: Representa o índice numérico (começando em `0` até `count - 1`).
* **Identificador**: Os recursos gerados tornam-se indexados como listas: `<TIPO>.<NOME>[<INDEX>]`.

```hcl
resource "local_file" "arquivos" {
  count    = 3
  filename = "/home/gus/arquivo_${count.index}.txt"
  content  = "Conteúdo do arquivo número ${count.index}"
}
```

> ⚠️ **Limitação do `count`:** Se você usar `count` com uma lista e remover um item do meio dela, o Terraform precisará recriar/deslocar todos os recursos subsequentes porque os índices mudam. Para coleções com chaves únicas, prefira `for_each`.

---

### 2. `for_each` (Múltiplas Instâncias por Chave/Valor)
Cria múltiplas instâncias a partir de um **`map`** ou de um **`set de strings`** (`toset(...)`).
* **Objetos disponíveis:**
  * `each.key`: A chave do item do mapa ou o valor da string do set.
  * `each.value`: O valor associado à chave no mapa.
* **Identificador**: Os recursos são identificados pelo nome da chave: `<TIPO>.<NOME>["<KEY>"]`.

```hcl
resource "local_file" "usuarios" {
  for_each = toset(["ana", "carlos", "beatriz"])

  filename = "/home/gus/${each.key}.txt"
  content  = "Configurações do usuário ${each.key}"
}
```

#### Exemplo com `map`:
```hcl
variable "servidores" {
  type = map(string)
  default = {
    web = "t3.micro"
    db  = "t3.medium"
  }
}

resource "local_file" "configs" {
  for_each = var.servidores

  filename = "/home/gus/${each.key}.conf"
  content  = "Tipo da instancia: ${each.value}"
}
```

> 💡 **`count` vs `for_each`:**
> * Use `count` quando os recursos forem praticamente idênticos ou quando quiser ativar/desativar um recurso condicionalmente (`count = var.habilitar ? 1 : 0`).
> * Use `for_each` quando os recursos dependerem de uma lista/mapa de itens identificáveis e puderem ser adicionados ou removidos sem alterar a ordem dos outros.
> * **Regra:** `count` e `for_each` **não** podem ser usados simultaneamente no mesmo bloco de recurso.

---

### 3. `depends_on` (Dependência Explícita)
Define explicitamente a ordem de criação quando o Terraform não consegue inferir dependências automaticamente por meio de interpolação de atributos.
* Aceita uma **lista** de recursos ou módulos.
* Na criação (`apply`), o recurso com `depends_on` só é criado após a conclusão do recurso referenciado.
* Na destruição (`destroy`), a ordem é invertida automaticamente.

```hcl
resource "local_file" "relatorio" {
  filename   = "/home/gus/relatorio.txt"
  content    = "Relatório consolidado"
  depends_on = [random_pet.meu_pet]
}
```

---

### 4. `provider` (Seleção de Alias de Provedor)
Permite especificar uma instância não padrão de um provider configurado com `alias` (por exemplo, ao trabalhar com múltiplas regiões ou contas no mesmo projeto).

```hcl
# Configuração do provider no projeto
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# Uso no recurso
resource "aws_s3_bucket" "bucket_west" {
  provider = aws.west
  bucket   = "meu-bucket-em-oregon"
}
```

---

### 5. Bloco `lifecycle` (Ciclo de Vida do Recurso)
O bloco `lifecycle` personaliza o comportamento padrão do CRUD (Create, Read, Update, Delete) do Terraform.

```hcl
resource "random_pet" "servidor" {
  length = 2

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [length]
  }
}
```

#### Argumentos disponíveis dentro de `lifecycle`:

1. **`create_before_destroy` (boolean)**:
   * **Padrão:** O Terraform destrói o recurso antigo e cria o novo quando uma alteração exige substituição (*destroy-and-recreate*).
   * **Com `true`:** Cria primeiro o novo recurso substituto e, somente após o sucesso da criação, destrói o antigo. Essencial para implantações sem indisponibilidade (*zero downtime*).

2. **`prevent_destroy` (boolean)**:
   * Proteção contra deleções acidentais.
   * Se definido como `true`, qualquer plano que resulte na destruição do recurso emitirá um erro impedindo o `apply`. Ideal para bancos de dados de produção ou buckets de armazenamento críticos.

3. **`ignore_changes` (list ou `all`)**:
   * Instruções para ignorar alterações feitas fora do Terraform (no console da nuvem ou por outros processos) em atributos específicos:
     ```hcl
     ignore_changes = [tags, tags["Environment"]]
     # ou para ignorar qualquer mudança externa:
     ignore_changes = all
     ```

4. **`replace_triggered_by` (list)**:
   * Introduzido no Terraform 1.2+.
   * Força a substituição (recriação) do recurso sempre que qualquer recurso ou atributo especificado na lista for alterado.
     ```hcl
     lifecycle {
       replace_triggered_by = [local_file.config_app.id]
     }
     ```

5. **`precondition` e `postcondition` (Validações customizadas)**:
   * Introduzido no Terraform 1.2+.
   * Permite asserções antes da criação (`precondition`) ou após a criação com base no estado retornado (`postcondition`).
     ```hcl
     lifecycle {
       precondition {
         condition     = var.ambiente != "prod" || var.instancias >= 3
         error_message = "Ambientes de produção exigem no mínimo 3 instâncias."
       }
     }
     ```

---

### 6. `provisioner` e `connection` (Ações Pós-Criação)
Utilizados para executar scripts ou comandos locais/remotos durante o ciclo de vida do recurso.

* **Tipos de Provisioners:**
  * `local-exec`: Executa um comando na máquina onde o Terraform está rodando.
  * `remote-exec`: Executa comandos via SSH/WinRM na máquina provisionada.
  * `file`: Copia arquivos para a máquina remota.

```hcl
resource "local_file" "aviso" {
  filename = "/home/gus/aviso.txt"
  content  = "Pronto!"

  provisioner "local-exec" {
    command = "echo 'Arquivo criado em: $(date)' >> /home/gus/log.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Arquivo destruído em: $(date)' >> /home/gus/log.txt"
  }
}
```

* **Argumentos do Provisioner:**
  * `when = destroy`: Executa o provisioner durante a destruição do recurso.
  * `on_failure = continue | fail`: Determina se uma falha no script interrompe ou não a execução do Terraform.

> ⚠️ **Recomendação Oficial da HashiCorp:** Provisioners são considerados um **último recurso** (*last resort*). Sempre prefira utilizar ferramentas de automação como `cloud-init`, imagens pré-construídas (Packer) ou gerenciadores de configuração (Ansible).

---

## 📦 Meta-Arguments para Módulos (`module`)

Quando instanciamos um módulo no Terraform (`module "nome" { ... }`), também temos meta-argumentos suportados:

1. **`source`**: *(Obrigatório)* Caminho local ou URL do repositório/registro do módulo.
2. **`version`**: Versão do módulo a ser usada (quando carregado de um Registry).
3. **`count`**: Cria múltiplas instâncias de todo o módulo.
4. **`for_each`**: Cria instâncias do módulo baseadas em um mapa ou conjunto de strings.
5. **`providers`**: Mapeia explicitamente configurações de provedores da raiz para os provedores internos do módulo.
6. **`depends_on`**: Garante que todo o módulo seja provisionado após a conclusão de outros recursos/módulos.

---

## ⚠️ Regra de Ouro: Variáveis (`variable`) vs Valores Dinâmicos
* O bloco `variable "<NOME>" { default = ... }` aceita **apenas literais estáticos** (constantes).
* **Não é permitido** usar `count.index`, `each.key`, funções dinâmicas ou referências a outros recursos dentro de um `default` em `variables.tf`.
* Para trabalhar com valores derivados ou computados, utilize:
  * **Interpolação direta no `main.tf`** (ex: `content = "Pet: ${random_pet.meu_pet[count.index].id}"`)
  * **Bloco `locals { ... }`** para criar variáveis locais reutilizáveis.

---

## 💻 Código Prático do Lab (`labs/05-meta-arguments/main.tf`)

```hcl
resource "local_file" "nome_pet" {
  count = 5

  filename = "/home/gus/pet_${count.index}.txt"
  content  = "O nome do meu pet de número ${count.index} é ${random_pet.meu_pet[count.index].id}"

  depends_on = [random_pet.meu_pet]

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_pet" "meu_pet" {
  count  = 5
  length = 2

  lifecycle {
    create_before_destroy = true
  }
}
```
