resource "random_pet" "meu_pet" {
  length = 1
}

resource "local_file" "arquivo_pet" {
    filename = "/home/gus/pet_terraform.txt"
    content  = "Meu pet gerado pelo terraform é ${random_pet.meu_pet.id}"
}