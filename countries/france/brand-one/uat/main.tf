locals {
  brand       = "fr-brand-one"
  environment = "uat"
}

module "api" {
  source                    = "../../../../infrastructure/api/uat"
  organization              = "${var.organization}"
  application_name          = "${var.application_name}"
  environment_name          = "fr-brand-one-uat"
  ec2_key_name              = "${var.ec2_key_name}"
  vpc_id                    = "${var.vpc_id}"
  public_subnet_ids         = "${var.public_subnet_ids}"
  region                    = "${var.region}"
  elasticbeanstalk_ec2_role = "${var.elasticbeanstalk_ec2_role}"
}

# Client Panel

module "client_panel_bucket" {
  source = "../../../../infrastructure/client-panel/bucket"

  organization = "${var.organization}"
  bucket_name  = "fr-brand-one-client-panel-uat"
}

module "client_panel_cdn" {
  source = "../../../../infrastructure/client-panel/cdn"

  brand                               = "${local.brand}"
  elastic_beanstalk_environment_cname = "${module.api.elastic_beanstalk_environment_cname}"
  elastic_beanstalk_environment_id    = "${module.api.elastic_beanstalk_environment_id}"
  environment                         = "${local.environment}"
  organization                        = "${var.organization}"
  s3_bucket_id                        = "${module.client_panel_bucket.s3_bucket_id}"
  s3_bucket_regional_domain_name      = "${module.client_panel_bucket.s3_bucket_regional_domain_name}"
}

# Backoffice

module "backoffice" {
  source       = "../../../../infrastructure/backoffice/bucket"
  organization = "${var.organization}"
  bucket_name  = "fr-brand-one-backoffice-uat"
}

module "cdn" {
  source = "../../../../infrastructure/backoffice/cdn"

  brand                               = "${local.brand}"
  elastic_beanstalk_environment_cname = "${module.api.elastic_beanstalk_environment_cname}"
  elastic_beanstalk_environment_id    = "${module.api.elastic_beanstalk_environment_id}"
  environment                         = "${local.environment}"
  organization                        = "${var.organization}"
  s3_bucket_id                        = "${module.backoffice.s3_bucket_id}"
  s3_bucket_regional_domain_name      = "${module.backoffice.s3_bucket_regional_domain_name}"
}
