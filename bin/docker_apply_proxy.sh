#!/bin/bash

if [[ $# != 1 ]]; then
    echo "You need to supply ip hint"
    exit 1
fi

# 配置你的代理地址（根据实际情况修改）
HTTP_PROXY=http://192.168.0.${1}:7890
HTTPS_PROXY=http://192.168.0.${1}:7890
NO_PROXY="localhost,127.0.0.1"

cat <<EOF | tee /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY}"
Environment="HTTPS_PROXY=${HTTPS_PROXY}"
Environment="NO_PROXY=${NO_PROXY}"
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl restart docker

echo "✅ Docker proxy 配置完成！当前代理地址："
echo "HTTP_PROXY=${HTTP_PROXY}"
