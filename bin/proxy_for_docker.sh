#proxy=http://10.0.0.3:7890/
#cat > /etc/systemd/system/docker.service.d/http_proxy.conf << EOF
#[Service]
#Environment="HTTP_PROXY=${proxy}"
#Environment="HTTPS_PROXY=${proxy}"
#EOF

cat > /etc/systemd/system/docker.service.d/http_proxy.conf << EOF
EOF

systemctl daemon-reload
systemctl restart docker
