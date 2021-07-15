# Bring your own key to IBM Cloud

What is needed to bring your own key (BYOK) to IBM Cloud? What are the steps to create and later rotate root keys from your own key material? This repository holds some scripts and instructions to easily BYOK. Parts of the setup can be automated using Terraform, others require some local preparation and should be performed manually. The resources apply to both Key Protect (KP) and Hyper Protect Crypto Services (HPCS). The services are commonly referred to as Key Management Services / Systems (KMS).


# Scripts
The following scripts can help to create and rotate root keys when using an import token, i.e., for bringing in your own key material.

- [create_key.sh](scripts/create_key.sh): Create a new root key from existing key material.
- [rotate_key.sh](scripts/rotate_key.sh): Rotate an existing root key by importing key material.

Both scripts require the [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-install-ibmcloud-cli) with the Key Protect plugin to be installed. In addition, the tool [jq](https://stedolan.github.io/jq/) is needed to process JSON data.

The script **create_key.sh** requires three variables to be set:
- **KP_INSTANCE_ID**: The instance ID for KP or HPCS.
- **KP_KEY_NAME**: The name of the new key to create.
- **KEY_FILE**: Name of the file holding the key in plain text.

It is similar for **rotate_key.sh**:
- **KP_INSTANCE_ID**: The instance ID for KP or HPCS.
- **KP_KEY_ID**: The ID of the key to rotate.
- **KEY_FILE**: Name of the file holding the key in plain text.

Optionally, specify a **KP_KEYRING_ID** to identify an existing key ring. Usually, the variable KP_INSTANCE_ID is already set to work with the IBM Cloud CLI on a KMS instance.

With KP_INSTANCE_ID in place and you logged in to IBM Cloud, an invocation of the create script could look like this:
```sh
KP_KEYRING_ID=henrik-keyring1 KP_KEY_NAME=MyTestKey KEY_FILE=/home/henrik/secrets/PlainTextKey.bin ./create_key.sh
```

# Python sample

See the [README.md](kms-encrypt-nonce/README.md) for information on the included Python script to encrypt the nonce for importing your own keys.