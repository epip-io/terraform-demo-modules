module "state_backend" {
  source = "../"

  namespace          = var.namespace
  environment        = var.environment
  stage              = var.stage
  name               = var.name
  delimiter          = var.delimiter
  attributes         = var.attributes
  tags               = var.tags
  additional_tag_map = var.additional_tag_map
  region             = var.region
  force_destroy      = var.force_destroy
}
