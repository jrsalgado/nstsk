#!/bin/bash
THUMBPRINT=$(echo | openssl s_client -servername oidc.eks.us-east-1.amazonaws.com -showcerts -connect oidc.eks.us-east-1.amazonaws.com:443 2>&- | tac | sed -n '/-----END CERTIFICATE-----/,/-----BEGIN CERTIFICATE-----/p; /-----BEGIN CERTIFICATE-----/q' | tac | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}')
THUMBPRINT_JSON="{\"thumbprint\": \"${THUMBPRINT}\"}"
echo "${THUMBPRINT_JSON}"