pkg update -y
pkg upgrade -y
pkg install -y openssl libnghttp3 libngtcp2
pkg install -y curl
curl -s https://api.github.com > /dev/null || { echo "curl ยังพัง หยุด"; exit 1; }
chmod +x install.sh
COLUMNS & LINES
export COLUMNS LINES
bash install.sh