#!/bin/bash
set -e

# 配置参数
NS=myns
VETH_HOST=veth-host
VETH_NS=veth-ns
IP_HOST=10.10.10.1
IP_NS=10.10.10.2
OUT_IFACE=enp4s0    # 实际联网的物理网卡

# 清理逻辑
if [[ "$1" == "clean" ]]; then
    echo "[*] Cleaning up..."
    sudo ip netns del $NS 2>/dev/null || true
    sudo ip link del $VETH_HOST 2>/dev/null || true
    sudo iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o $OUT_IFACE -j MASQUERADE 2>/dev/null || true
    sudo iptables -D FORWARD -i $VETH_HOST -o $OUT_IFACE -j ACCEPT 2>/dev/null || true
    sudo iptables -D FORWARD -o $VETH_HOST -i $OUT_IFACE -j ACCEPT 2>/dev/null || true
    # sudo iptables -D OUTPUT -s 10.10.10.0/24 -o enp4s0 -j ACCEPT 2>/dev/null || true
    sudo ip rule del from 10.10.10.0/24 lookup main priority 100 2>/dev/null || true
    sudo rm -rf /etc/netns/$NS
    echo "[✔] Clean done."
    exit 0
fi

echo "[*] Creating netns: $NS"
sudo ip netns add $NS

echo "[*] Creating veth pair"
sudo ip link add $VETH_HOST type veth peer name $VETH_NS
sudo ip link set $VETH_NS netns $NS

echo "[*] Configuring host veth"
sudo ip addr add $IP_HOST/24 dev $VETH_HOST
sudo ip link set $VETH_HOST up

echo "[*] Configuring netns veth"
sudo ip netns exec $NS ip addr add $IP_NS/24 dev $VETH_NS
sudo ip netns exec $NS ip link set $VETH_NS up
sudo ip netns exec $NS ip link set lo up

echo "[*] Enabling routing"
sudo sysctl -w net.ipv4.ip_forward=1 > /dev/null

echo "[*] Adding NAT for $OUT_IFACE"
sudo iptables -t nat -C POSTROUTING -s 10.10.10.0/24 -o $OUT_IFACE -j MASQUERADE 2>/dev/null || \
sudo iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o $OUT_IFACE -j MASQUERADE

echo "[*] Allowing forwarding"
sudo iptables -C FORWARD -i $VETH_HOST -o $OUT_IFACE -j ACCEPT 2>/dev/null || \
sudo iptables -A FORWARD -i $VETH_HOST -o $OUT_IFACE -j ACCEPT
sudo iptables -C FORWARD -o $VETH_HOST -i $OUT_IFACE -j ACCEPT 2>/dev/null || \
sudo iptables -A FORWARD -o $VETH_HOST -i $OUT_IFACE -j ACCEPT

echo "[*] Setting default route inside namespace"
sudo ip netns exec $NS ip route add default via $IP_HOST

echo "[*] Forcing namespace to use main routing table"
sudo ip netns exec $NS ip rule add from $IP_NS/32 table main priority 100
# ip rule 设置路由规则，该条规则需要添加，覆盖wg0生效时启用的规则
sudo ip rule add from 10.10.10.0/24 lookup main priority 100
# iptables命令设置防火墙规则
# sudo iptables -I OUTPUT -s 10.10.10.0/24 -o enp4s0 -j ACCEPT     # 实测，这个防火墙规则无需添加


echo "[*] Setting DNS"
sudo mkdir -p /etc/netns/$NS
echo -e "nameserver 1.1.1.1\nnameserver 8.8.8.8" | sudo tee /etc/netns/$NS/resolv.conf > /dev/null

echo "[✔] Network namespace $NS setup complete."

exec sudo ip netns exec myns bash -c 'su - shenming'

