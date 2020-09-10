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
