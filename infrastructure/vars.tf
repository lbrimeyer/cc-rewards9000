#############
## General ##
#############
variable "app_name" {
  type = string
}

#########
## S3 ##
#########
variable "domain_name" {
  description = "The name of the s3 bucket that will match thet website name"
}

variable "s3_storage_class" {
  default     = "ONEZONE_IA"
  description = "Set the storage class for the bucket. Default is One Zone Infrequent Access"
}

variable "s3_transition_days" {
  default     = 30
  description = "Number of days that pass before transition to the cheaper storage class automatically triggers"
}

variable "s3_transition_flag" {
  default     = true
  description = "Boolean deciding whether or not transition is enabled. Default is true"
}

variable "s3_acl" {
  default     = "private"
  description = "Set the acl for the bucket. Default is private because cloudfront will be accessing the bucket."
}

################################
## OpenID Connection Provider ##
################################
variable "openid_connect_provider_url" {
  type = string
}

variable "openid_connect_provider_client_ids" {
  type = list(string)
}

variable "openid_connect_provider_thumbprints" {
  type = list(string)
}

#############
## Cognito ##
#############
variable "cognito_pool_name" {
  type = string
}

################
## CloudFront ##
################
variable "cf_price_class" {
  default     = "PriceClass_100"
  description = "Set the price class. Defaults to Price Class 100, the cheapest version optimized only for US and Europe"
}

variable "cf_root_domain" {
  description = "ARN for ACM Certificate, must be from US-EAST-1???"
  type = string
}

variable "origin_access_identity" {
  description = "Unfortunately there isn't a data source for querying an existing id"
  type = string
}

variable "origin_access_identity_iam_arn" {
  description = "Unfortunately there isn't a data source for querying an existing id"
  type = string
}

################
## DynamoDB ##
################
variable "ddb_billing_mode" {
  type = string
  default = "PAY_PER_REQUEST"
}

variable "ddb_partition_key_name" {
  type = string
  default = "Id"
}

variable "ddb_partition_key_type" {
  type = string
  description = "Valid values are S (string), N (number)"
  default = "S"
}
