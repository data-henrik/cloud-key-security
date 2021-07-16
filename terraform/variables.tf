variable "ibmcloud_api_key" {}

variable "region" {
  default = "us-south"
}

variable "ibmcloud_timeout" {
  description = "Timeout for API operations in seconds."
  default     = 900
}


# enable if using import token
# variable "encrypted_nonce" {}
# variable "iv_value" {}