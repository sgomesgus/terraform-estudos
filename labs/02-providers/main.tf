resource "local_file" "pet" {
  filename = "/home/gus/pets.txt"
  content = "Nós amamos animais!!!"
  file_permission = "0700"
}

resource "random_pet" "my-pet" {
  prefix = "Sra"
  separator = ". "
  length = "1"
}
