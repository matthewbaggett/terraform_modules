locals {
  is_build   = var.build != null
  image_name = split(":", var.image)[0]

  source_files             = local.is_build ? fileset(var.build.context, "**") : []
  source_file_hashes       = [for f in local.source_files : filesha1("${var.build.context}/${f}")]
  image_context_hash       = sha1(join("", local.source_file_hashes))
  image_context_hash_short = substr(local.image_context_hash, 0, 8)
  image_build_date         = formatdate("YYMMDD", plantimestamp())
  tags = [
    "${local.image_name}:hash-${local.image_context_hash_short}",
    "${local.image_name}:built-${local.image_build_date}",
  ]
}
resource "random_pet" "build" {
  for_each = local.is_build ? { "build" = {} } : {}
  keepers = {
    image_name    = local.image_name
    build_context = var.build.context
    dockerfile    = var.build.dockerfile
    target        = var.build.target
    tags          = jsonencode(local.tags)
    hash          = local.image_context_hash
    args          = jsonencode(var.build.args)
    dockerfile    = var.build.dockerfile
  }
}
# MB: This is a hack to allow replace_triggered_by on a resource that may or may not exist.
resource "terraform_data" "conditional_build" {
  input = try(jsonencode(random_pet.build["build"].keepers), null)
}
// Do the build
resource "docker_image" "build" {
  for_each     = local.is_build ? { "build" = {} } : {}
  name         = var.image
  force_remove = false
  build {
    # We are reading these variables via the random_pet entity to ensure that the build is triggered when changes happen
    context         = random_pet.build["build"].keepers.build_context
    tag             = jsondecode(random_pet.build["build"].keepers.tags)
    target          = random_pet.build["build"].keepers.target
    build_args      = jsondecode(random_pet.build["build"].keepers.args)
    dockerfile      = random_pet.build["build"].keepers.dockerfile
    remove          = false
    suppress_output = false
  }
  lifecycle {
    replace_triggered_by  = [terraform_data.conditional_build, ]
    create_before_destroy = true
  }
}

// Push it to the registry
resource "docker_registry_image" "build" {
  depends_on    = [docker_image.build]
  for_each      = local.is_build ? { "build" = {} } : {}
  name          = docker_image.build["build"].name
  keep_remotely = true
  lifecycle {
    replace_triggered_by = [terraform_data.conditional_build]
  }
}
resource "docker_registry_image" "tags" {
  depends_on    = [docker_registry_image.build]
  for_each      = local.is_build ? toset(local.tags) : []
  name          = each.value
  keep_remotely = true
  lifecycle {
    replace_triggered_by = [terraform_data.conditional_build]
    ignore_changes = [
      name,
    ]
  }
}

output "built_tags" {
  value = local.is_build ? local.tags : []
}