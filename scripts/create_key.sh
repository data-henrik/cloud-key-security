# Create a new root key
#
# The script requires three variables to be set:
# - KP_INSTANCE_ID: The instance ID for KP or HPCS.
# - KP_KEY_NAME:    The name of the new key to create.
# - KEY_FILE:       Name of the file holding the key in plain text.
#
# Optionally, specify a KP_KEYRING_ID to identify an existing key ring.
#
# Often, KP_INSTANCE_ID is already set when working with the
# IBM Cloud CLI and the Key Protect plugin,
#
# The script requires that you are logged in to IBM Cloud and that
# the KP plugin is installed. Moreover, the tool "jq" is needed.


if [ -z "$KP_INSTANCE_ID" ]; then
    echo "KP_INSTANCE_ID required, instance ID"
    exit
fi

if [ -z "$KP_KEY_NAME" ]; then
    echo "KP_KEY_NAME required, the name of the key to create"
    exit
fi

if [ -z "$KEY_FILE" ]; then
    echo "KEY_FILE required, file with plan text key"
    exit
fi

if [ -z "$KP_KEYRING_ID" ]; then
    echo "No keyring specified"
    export KEYRING_CLAUSE=
else
    echo "keyring specified"
    export KEYRING_CLAUSE="--key-ring ${KP_KEYRING_ID}"
fi

export KEY_MATERIAL=$(openssl enc -base64 -A -in ${KEY_FILE})


ibmcloud kp import-token create -i ${KP_INSTANCE_ID} -e 600 $KP_KEYRING_CLAUSE


# Retrieve the token in JSON format and store it for postprocessing
IMPORT_TOKEN_JSON=$(ibmcloud kp import-token show -i ${KP_INSTANCE_ID} $KP_KEYRING_CLAUSE --output json)

echo $IMPORT_TOKEN_JSON | jq

echo "Extracting nonce and public key"
export NONCE=$(echo $IMPORT_TOKEN_JSON | jq -r '.nonce')
PUBLIC_KEY=$(echo $IMPORT_TOKEN_JSON | jq -r '.payload')

echo "encrypting nonce"
ENCRYPTED_VALUES=$(ibmcloud kp import-token nonce-encrypt -k $KEY_MATERIAL -n $NONCE --output json)

echo $ENCRYPTED_VALUES | jq

echo "extract encrypted values"
KEYROTATE_ENC_NONCE=$(echo $ENCRYPTED_VALUES | jq -r '.encryptedNonce')
KEYROTATE_IV=$(echo $ENCRYPTED_VALUES | jq -r '.iv')

echo "encrypt key material"
ENC_KEY_MATERIAL=$(ibmcloud kp import-token key-encrypt -k $KEY_MATERIAL -p $PUBLIC_KEY --output json | jq -r '.encryptedKey')

echo "creating"
ibmcloud kp key create $KP_KEY_NAME -i ${KP_INSTANCE_ID} -k "${ENC_KEY_MATERIAL}" -n "${KEYROTATE_ENC_NONCE}" -v "${KEYROTATE_IV}" $KP_KEYRING_CLAUSE
