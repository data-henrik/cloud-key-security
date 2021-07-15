# Encrypt Nonce

The Python script [kms-encrypt-nonce.py](kms-encrypt-nonce.py) provides similar functionality as the [sample Golang app provided by IBM Cloud](https://github.com/IBM-Cloud/kms-samples/tree/master/secure-import). It can be used as part of the process to securely import your own key material (BYOK / bring you own key) into either Key Protect or Hyper Protect Crypto Services. The same encryption can be performed using the [IBM Cloud CLI command `ibmcloud kp import-token nonce-encrypt`](https://cloud.ibm.com/docs/key-protect?topic=key-protect-cli-plugin-key-protect-cli-reference#kp-import-token-nonce-encrypt).

It requires the environment variables KEY_MATERIAL (your base64-encoded key to import) and NONCE (base64-encoded nonce provided as part of the import token) to be set. Optionally, you can also set the variable KEYENCRYPT_IV to the IV (initialization vector / nonce) used by another tool. That way the results can be verified.

See [PyCryptodome for background information on the utilized GCM interface](https://pycryptodome.readthedocs.io/en/latest/src/cipher/aes.html).