resource "local_file" "whale" {
  filename = "/home/gus/whale"
  content = "whale"

  depends_on = [ 
    local_file.krill 
  ]
}

resource "local_file" "krill" {
  filename = "/home/gus/krill"
  content = "krill"
}
