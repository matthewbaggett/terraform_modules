locals {
  // strip off the tag
  image_name = split(":", var.image)[0]

  source_files             = fileset(var.build.context, "**")
  source_file_hashes       = [for f in local.source_files : filesha1("${var.build.context}/${f}")]
  image_context_hash       = sha1(join("", local.source_file_hashes))
  image_context_hash_short = substr(local.image_context_hash, 0, 8)
  image_build_date         = formatdate("YYMMDD", plantimestamp())
  tags =  [
    "${local.image_name}:hash-${local.image_context_hash_short}",
    "${local.image_name}:built-${local.image_build_date}",
  ]
}
resource "random_pet" "build" {
  count = local.is_build ? 1 : 0
  keepers = {
    image_name = local.image_name
    build_context = var.build.context
    dockerfile = var.build.dockerfile
    target = var.build.target
    tags = jsonencode(local.tags)
    hash = local.image_context_hash
  }
}
// Do the build
resource "docker_image" "build" {
  count = local.is_build ? 1 : 0
  name  = var.image
  force_remove = true
  build {
    # We are reading these variables via the random_pet entity to ensure that the build is triggered when changes happen
    context = random_pet.build[0].keepers.build_context
    tag     = jsondecode(random_pet.build[0].keepers.tags)
    target = random_pet.build[0].keepers.target
    remove  = false
  }
  lifecycle {
    ignore_changes = [
      build,
    ]
    replace_triggered_by = [random_pet.build]
  }
}

// Push it to the registry
resource "docker_registry_image" "build" {
  count         = local.is_build ? 1 : 0
  name          = docker_image.build[0].name
  keep_remotely = true
  lifecycle {
    replace_triggered_by = [random_pet.build]
  }
}
resource "docker_registry_image" "tags" {
  for_each = local.is_build ? toset(local.tags) : []
  name          = each.value
  keep_remotely = true
  lifecycle {
    replace_triggered_by = [random_pet.build]
  }
}

output "built_tags" {
  value = local.is_build ? local.tags : []
}