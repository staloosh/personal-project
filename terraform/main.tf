module "iam" {
  source      = "./modules/iam"
  tags        = local.required_tags
  environment = var.environment
  app         = var.app
}

locals {
  required_tags = {
    "environment" = var.environment
    "application" = var.app
  }
}