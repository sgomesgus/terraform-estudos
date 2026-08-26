# Lab 05 - Dependências Explícitas (`depends_on`)

## 📌 Visão Geral
Neste laboratório, foi explorado o uso de **dependências explícitas** através do meta-argumento `depends_on`, garantindo a ordem estrita de criação de recursos mesmo quando não há referência direta de atributos entre eles.

---

## 📖 Conceitos Aprendidos

### 1. Dependência Implícita vs Explícita
* **Implícita**: Ocorre automaticamente quando um recurso usa um atributo de outro (ex: `var.id` ou `recurso.outro_recurso.id`). O Terraform descobre a ordem sozinho.
* **Explícita (`depends_on`)**: Utilizada quando um recurso depende de outro operacionalmente, mas seus atributos não são diretamente referenciados no código.

---

### 2. O Meta-Argumento `depends_on`
* Aceita uma lista de recursos que devem ser concluídos antes do recurso atual iniciar.
* Sintaxe:
  ```hcl
  depends_on = [
    <TIPO_RECURSO>.<NOME_RECURSO>
  ]
  ```

---

## 💻 Exemplo Prático (`main.tf`)

```hcl
resource "local_file" "whale" {
  filename = "/home/gus/whale"
  content  = "whale"

  depends_on = [
    local_file.krill
  ]
}

resource "local_file" "krill" {
  filename = "/home/gus/krill"
  content  = "krill"
}
```

### Comportamento de Execução:
* **Criação (`terraform apply`)**:
  1. `local_file.krill` é criado primeiro.
  2. `local_file.whale` é criado somente após a criação do `krill` ser concluída com sucesso.
* **Destruição (`terraform destroy`)**:
  * A ordem de destruição é **invertida**: `whale` é destruído primeiro, e em seguida `krill`.
