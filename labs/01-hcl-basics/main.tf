resource "local_file" "pet" {
  filename = "/home/gus/pets.txt"
  content = "Nós amamos animais!!!"
  file_permission = "0700"
}
