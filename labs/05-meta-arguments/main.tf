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