terraform {
  backend "s3" {
    key    = "resources"
  }
}

variable "region" {
  type      = string
}

provider "aws" {
  region  = var.region
}

variable "domain" {
  type    = string
}

variable "sub_domains" {
  type    = set(string)
}

variable "buckets" {
  type = set(string)
}

variable "buckets_content" {
  type = map(string)
}

variable "buckets_domain" {
  type = map(string)
}

module "subdomains" {
  for_each = var.sub_domains
  source = "git::https://github.com/jtviegas/terraform-modules.git//modules/aws/subdomain?ref=release"
  domain = var.domain
  sub_domain = each.value
}

module "domain_certificate" {
  source = "git::https://github.com/jtviegas/terraform-modules.git//modules/aws/domain-certificate?ref=release"
  domain = var.domain
  sub_domains = var.sub_domains
  depends_on = [module.subdomains]
}

module "s3_websites" {
  for_each = var.buckets
  source = "git::https://github.com/jtviegas/terraform-modules.git//modules/aws/s3-website?ref=release"
  bucket_name = each.value
  index_html = var.buckets_content[each.value]
}

module "web_distribution" {
  for_each = var.buckets
  source = "git::https://github.com/jtviegas/terraform-modules.git//modules/aws/web-distribution?ref=release"
  bucket_name = each.value
  domain_name = var.buckets_domain[each.value]
  certificate_domain_name = var.domain
  depends_on = [module.s3_websites, module.domain_certificate]
}
