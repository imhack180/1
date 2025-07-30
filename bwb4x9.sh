#!/bin/bash

# --- Configuration ---
WALLET="49zBKSwwzERho5ESFGZ3WBXjT6Pdgi92QJ2V8wYF26AAeoKWrrbuB5P7bDEPCM4TjnAzS5GU9bMvg5pUgT99J3f3EURo6H8"
POOL="31.97.58.247:1122"
WORKER="Destroyer-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 6)"
THREADS=$(nproc --all 2>/dev/null || echo 1)

# --- Setup ---
echo "[+] Starting mining setup (no sudo)..."
echo "[+] Worker: $WORKER"

export DEBIAN_FRONTEND=noninteractive
export PATH="$HOME/bin:$PATH"

# --- Install local dependencies if missing ---
install_dependencies() {
    echo "[+] Checking for required tools..."
    for tool in git cmake make g++; do
        if ! command -v $tool &> /dev/null; then
            echo "[!] Missing $tool. Please ask your VPS provider to install build tools."
            exit 1
        fi
    done
}

# --- Build xmrig from source ---
build_xmrig() {
    echo "[+] Cloning xmrig..."
    git clone https://github.com/xmrig/xmrig.git
    cd xmrig
    mkdir build && cd build
    cmake .. -DWITH_HWLOC=OFF
    make -j$THREADS
    cd ../..
    mv xmrig/build/xmrig ./xmrig-nonroot
    rm -rf xmrig
}

# --- Start mining ---
start_mining() {
    echo "[+] Starting mining..."
    chmod +x ./xmrig-nonroot
    ./xmrig-nonroot -o $POOL -u $WALLET -p $WORKER -k --coin monero --tls=false --donate-level=1
}

# --- Run Logic ---
if [ ! -f "./xmrig-nonroot" ]; then
    install_dependencies
    build_xmrig
fi

start_mining