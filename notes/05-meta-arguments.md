# Lab 05 - Meta-Arguments (`count`, `depends_on`, `lifecycle`)

## 📌 Visão Geral
Neste laboratório, foram explorados os **Meta-Arguments (Meta-Argumentos)** no Terraform. Meta-argumentos são palavras-chave especiais que podem ser usadas dentro de qualquer bloco `resource` ou `module` para alterar o comportamento padrão de criação, contagem, ordenação ou ciclo de vida dos recursos.

---

## 📖 Conceitos Aprendidos

### 1. Meta-Argumento `count`
* Permite instanciar múltiplos recursos idênticos ou parametrizados sem duplicar código.
* Cria uma **lista** de recursos indexados de `0` a `count - 1`.
* **Objeto `count.index`**: Fornece o índice numérico da instância atual (0, 1, 2, ...).

```hcl
resource "random_pet" "meu_pet" {
  count  = 5
  length = 2
}
```

> **Atenção ao referenciar:** Quando um recurso utiliza `count`, para acessar um de seus atributos é necessário especificar o índice correspondente, por exemplo: `random_pet.meu_pet[count.index].id`.

---

### 2. Meta-Argumento `depends_on`
* Força a criação de recursos em uma ordem explícita caso não exista uma dependência implícita de atributos entre eles.
* Aceita uma lista de recursos:
  ```hcl
  depends_on = [random_pet.meu_pet]
  ```

---

### 3. Bloco `lifecycle`
Permite customizar o comportamento padrão de criação, destruição e atualização de recursos:

* **`create_before_destroy = true`**: Cria o novo recurso substituto antes de destruir o existente (útil para zero downtime).
* **`prevent_destroy = true`**: Impede que o Terraform destrua acidentalmente recursos críticos (emite erro no plano/apply).
* **`ignore_changes = [...]`**: Ignora alterações em atributos específicos feitas externamente ou fora do código Terraform.
* **`replace_triggered_by = [...]`**: Força a recriação do recurso quando outro recurso ou atributo especificado for alterado.

```hcl
lifecycle {
  create_before_destroy = true
}
```

---

### 4. Importante: Variáveis de Entrada vs Expressões Dinâmicas
* Blocos `variable` aceitam apenas valores literais constantes no campo `default`.
* **Não** é permitido usar `count.index`, referências de recursos ou outras variáveis dentro de valores `default` no `variables.tf`.
* Para valores dinâmicos ou calculados, use interpolação direta no `main.tf` ou blocos `locals { ... }`.

---

## 💻 Código Prático (`main.tf`)

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
