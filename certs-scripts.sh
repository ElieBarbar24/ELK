#!/bin/bash
set -e

CERT_DIR=/usr/share/elasticsearch/config/certs

if [ -z "$ELASTIC_PASSWORD" ]; then
  echo "❌ ELASTIC_PASSWORD not set"
  exit 1
fi

echo "▶ Creating CA (if not exists)..."
if [ ! -f ${CERT_DIR}/ca/ca.crt ]; then
  bin/elasticsearch-certutil ca --silent --pem -out ${CERT_DIR}/ca.zip
  unzip -o ${CERT_DIR}/ca.zip -d ${CERT_DIR}
fi

echo "▶ Creating instance definition file..."
cat > ${CERT_DIR}/instances.yml <<EOF
instances:
  - name: es01
    dns: [ "es01", "localhost" ]
    ip:  [ "127.0.0.1", "${ES01_IP}" ]

  - name: es02
    dns: [ "es02", "localhost" ]
    ip:  [ "127.0.0.1", "${ES02_IP}" ]

  - name: es03
    dns: [ "es03", "localhost" ]
    ip:  [ "127.0.0.1", "${ES03_IP}" ]
EOF

echo "▶ Creating node certificates..."
bin/elasticsearch-certutil cert --silent --pem \
  --in ${CERT_DIR}/instances.yml \
  --ca-cert ${CERT_DIR}/ca/ca.crt \
  --ca-key  ${CERT_DIR}/ca/ca.key \
  -out ${CERT_DIR}/certs.zip

unzip -o ${CERT_DIR}/certs.zip -d ${CERT_DIR}

echo "▶ Fixing permissions..."
chown -R root:root ${CERT_DIR}
find ${CERT_DIR} -type d -exec chmod 750 {} \;
find ${CERT_DIR} -type f -exec chmod 640 {} \;

echo "✅ Certificates successfully generated."