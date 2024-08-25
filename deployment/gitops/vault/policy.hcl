path "secret/data/platform/*" {
   capabilities = [ "create", "read", "update", "patch" ]
}

path "secret/platform/*" {
   capabilities = [  "read", "list" ]
}

path "*" {
   capabilities = ["deny"]
}
