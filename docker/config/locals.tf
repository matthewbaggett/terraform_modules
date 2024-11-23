locals {
  path      = var.name
  file_name = element(split("/", local.path), length(split("/", local.path)) - 1)
  // Name can be 64 bytes long, including a null byte seemingly, limiting the length to 63.
  // The hash is 7 bytes long. We lose 2 more bytes to the dashes. So we have 54 bytes left.
  // I will share that into 20 bytes for the stack name, remaining bytes for the config name
  config_name = join("-", [
    substr(var.stack_name, 0, 20),
    substr(local.file_name, 0, 64 - 1 - 7 - 2 - 20),
    substr(sha1(var.value), 0, 7)
  ])

  // define config labels
  labels = merge(var.labels, {
    "com.docker.stack.namespace" = var.stack_name
    "ooo.grey.config.stack"      = var.stack_name
    #"ooo.grey.config.created"   = timestamp()
    "ooo.grey.config.bytes" = length(var.value)
    "ooo.grey.config.name"  = local.config_name
    "ooo.grey.config.hash"  = sha1(var.value)
    "ooo.grey.config.file"  = local.file_name
    "ooo.grey.config.path"  = local.path
  })
}