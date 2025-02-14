locals {
  path      = var.name
  file_name = element(split("/", local.path), length(split("/", local.path)) - 1)
  // Name can be 64 bytes long, including a null byte seemingly, limiting the length to 63.
  // The hash is 7 bytes long. We lose 2 more bytes to the dashes. So we have 54 bytes left.
  // I will share that into 20 bytes for the stack name, remaining bytes for the config name
  secret_name = join("-", [
    substr(var.stack_name, 0, 20),
    substr(local.file_name, 0, 64 - 20 - 1 - (random_id.randomiser.byte_length * 2) - 1),
    random_id.randomiser.hex
  ])

  // define secret labels
  labels = merge(var.labels, {
    "com.docker.stack.namespace" = var.stack_name
    "ooo.grey.secret.stack"      = var.stack_name
    #"ooo.grey.secret.created"   = plantimestamp()
    "ooo.grey.secret.bytes" = length(var.value)
    "ooo.grey.secret.name"  = local.secret_name
    "ooo.grey.secret.hash"  = sha1(var.value)
    "ooo.grey.secret.file"  = local.file_name
    "ooo.grey.secret.path"  = local.path
  })
}