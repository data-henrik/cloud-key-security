# reference to default resource group
data "ibm_resource_group" "default_rg" {
  name = "default"
}

# create an instance of Key Protect
resource "ibm_resource_instance" "kms_instance" {
  name     = "my-kms"
  service  = "kms"
  plan     = "tiered-pricing"
  location = var.region
  resource_group_id = data.ibm_resource_group.default_rg.id
  service_endpoints = "private"
}

# create a key ring 
resource "ibm_kms_key_rings" "keyring" {
  instance_id = ibm_resource_instance.kms_instance.guid
  key_ring_id = "my-keyring"
}

# import existing key material, 
# protected only by regular SSL/TLS network encryption
resource "ibm_kms_key" "mykey1" {
  instance_id = ibm_resource_instance.kms_instance.guid
  key_name       = "my-key1"
  standard_key   = false
  payload = filebase64("local_keyfile.key")
  key_ring_id = ibm_kms_key_rings.keyring.key_ring_id
}

/*
# import existing key material,
# protected by additional import token (nonce)
resource "ibm_kms_key" "mykey2" {
  instance_id = ibm_resource_instance.kms_instance.guid
  key_name       = "my-key2"
  standard_key   = false
  key_ring_id = ibm_kms_key_rings.keyring.key_ring_id
  payload = filebase64("local_encrypted_keyfile.key")
  encrypted_nonce=var.encrypted_nonce
  iv_value=var.iv_value
}
*/

