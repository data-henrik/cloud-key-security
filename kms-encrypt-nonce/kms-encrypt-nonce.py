# Encrypt the KMS-issued nonce using the key material, so that
# it can be imported into Key Protect or Hyper Protect Crypto
# Services.
#
# By default, an Initialization Vector (IV) is generated and
# printed as result. It is needed for the import. If set as 
# environment variable, that IV is used instead. A use case
# is to verify the output by other tools - it requires to
# use the same initialization vector.
#
# Written by Henrik Loeser, hloeser@de.ibm.com

import json, os
from base64 import b64encode, b64decode
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

key_material=""
enc_nonce=""
iv=""

# read KEY_MATERIAL
if 'KEY_MATERIAL' in os.environ:
    enc_key_material=os.environ['KEY_MATERIAL']
else:
    print("Environment variable KEY_MATERIAL expected")
    quit()
# read NONCE
if 'NONCE' in os.environ:
    enc_nonce=os.environ['NONCE']
else:
    print("Environment variable NONCE expected")
    quit()

# 
key_material=b64decode(enc_key_material)
nonce=b64decode(enc_nonce)



if 'KEYENCRYPT_IV' in os.environ:
    # Read optional IV
    enc_iv=os.environ['KEYENCRYPT_IV']
    iv=b64decode(enc_iv)
else:
    # if not provided, generate IV
    iv=get_random_bytes(12)

# initialize for AES GCM including the IV
cipher = AES.new(key_material, AES.MODE_GCM, nonce=iv)

# encrypt the nonce
ciphertext, tag = cipher.encrypt_and_digest(nonce)

# the encrypted nonce is made up of the cipher and the tag
result={
    "encryptedNonce":b64encode(ciphertext).decode('utf-8')+b64encode(tag).decode('utf-8'),
    "iv":b64encode(cipher.nonce).decode('utf-8'),
    "cipher":b64encode(ciphertext).decode('utf-8'),
    "tag":b64encode(tag).decode('utf-8')
    }

# print out the JSON object
print(json.dumps(result, indent=2))