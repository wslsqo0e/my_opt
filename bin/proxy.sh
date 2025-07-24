#!/bin/bash
if [[ $# != 1 ]]; then
    echo "You need to supply ip hint"
else
    export https_proxy=http://192.168.0.${1}:7890 http_proxy=http://192.168.0.${1}:7890 all_proxy=socks5://192.168.0.${1}:7890 no_proxy="localhost,127.0.0.1"
fi
