provider "aws" {
  region  = var.region
}

# --- VARIABLES ---
variable "region" {
  type    = string
}
variable "solution" {
  type        = string
}
variable "group_name" {
  type      = string
}

variable "user_name" {
  type      = string
}

# --- RESOURCES ---

module "ops_group" {
  source = "git::https://github.com/jtviegas/terraform-modules.git//modules/aws/ops-group?ref=release"
  group_name = var.group_name
}
module "ops_user" {
  source = "git::https://github.com/jtviegas/terraform-modules.git//modules/aws/ops-user?ref=release"
  group_name = var.group_name
  user_name = var.user_name
}
module "remote_state" {
  source = "git::https://github.com/jtviegas/terraform-modules.git//modules/aws/remote-state?ref=release"
  solution = var.solution
}

# --- OUTPUTS ---
output "group_id" {
  value = module.ops_group.group_id
}
output "group_arn" {
  value = module.ops_group.group_arn
}
output "access_key" {
  value = module.ops_user.access_key
  sensitive = true
}
output "access_key_id" {
  value = module.ops_user.access_key_id
}
output "lock_state_table_arn" {
  value = module.remote_state.table_arn
}

output "lock_state_table_id" {
  value = module.remote_state.table_id
}

output "tf_state_bucket_arn" {
  value = module.remote_state.bucket_arn
}

output "tf_state_bucket_id" {
  value = module.remote_state.bucket_id
}