#!/bin/bash
# Proxy kurulumu - tum istekler proxy uzerinden

PROXY_URL="http://nwgyisbx:5t0x2ew4okxg@72.1.153.199:5591/"

echo "Proxy ayarlaniyor: $PROXY_URL"

# 1. /etc/environment (sistem geneli)
if ! grep -q "http_proxy" /etc/environment 2>/dev/null; then
    echo "" | sudo tee -a /etc/environment
    echo "# Proxy" | sudo tee -a /etc/environment
    echo "http_proxy=\"$PROXY_URL\"" | sudo tee -a /etc/environment
    echo "https_proxy=\"$PROXY_URL\"" | sudo tee -a /etc/environment
    echo "HTTP_PROXY=\"$PROXY_URL\"" | sudo tee -a /etc/environment
    echo "HTTPS_PROXY=\"$PROXY_URL\"" | sudo tee -a /etc/environment
    echo "no_proxy=\"localhost,127.0.0.1\"" | sudo tee -a /etc/environment
    echo "NO_PROXY=\"localhost,127.0.0.1\"" | sudo tee -a /etc/environment
    echo "[OK] /etc/environment guncellendi"
else
    echo "[SKIP] /etc/environment zaten ayarli"
fi

# 2. ~/.bashrc
PROXY_BLOCK='
# Proxy
export http_proxy="'"$PROXY_URL"'"
export https_proxy="'"$PROXY_URL"'"
export HTTP_PROXY="'"$PROXY_URL"'"
export HTTPS_PROXY="'"$PROXY_URL"'"
export no_proxy="localhost,127.0.0.1"
export NO_PROXY="localhost,127.0.0.1"
'

if ! grep -q "http_proxy" ~/.bashrc 2>/dev/null; then
    echo "$PROXY_BLOCK" >> ~/.bashrc
    echo "[OK] ~/.bashrc guncellendi"
else
    echo "[SKIP] ~/.bashrc zaten ayarli"
fi

# 3. Apt
sudo tee /etc/apt/apt.conf.d/95proxies << EOF
Acquire::http::Proxy "$PROXY_URL";
Acquire::https::Proxy "$PROXY_URL";
EOF
echo "[OK] Apt proxy ayarlandi"

# 4. Mevcut oturumda aktif et
export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export no_proxy="localhost,127.0.0.1"
export NO_PROXY="localhost,127.0.0.1"

echo ""
echo "Proxy aktif. Test: curl -s https://ipv4.webshare.io/"
curl -s https://ipv4.webshare.io/ && echo "" || echo "Baglanti hatasi"
echo ""
echo "Yeni terminal ac veya: source ~/.bashrc"
