#!/bin/bash

cat <<EOF | tee /etc/systemd/system/docker.service.d/http-proxy.conf
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl restart docker

echo "✅ Docker proxy cleared"
