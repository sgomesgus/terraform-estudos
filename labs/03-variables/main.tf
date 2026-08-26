resource "local_file" "pet_file" {
  filename = var.filename
  content  = "Meu pet se chama ${var.pet_name} e é um ${var.pet_type}."
}