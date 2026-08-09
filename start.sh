#!/bin/bash
set -e

mkdir -p /data/opencode

# 在虚拟主机创建数据目录（如果不存在）
lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" \
    -e "set ssl:verify-certificate no; mkdir -p /opencode-data; bye" 2>/dev/null || true

# 从虚拟主机拉取数据到容器
echo "[Sync] Pulling data from virtual host..."
lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" \
    -e "set ssl:verify-certificate no; mirror /opencode-data /data/opencode; bye" 2>/dev/null || true

# 链接 opencode 数据目录
rm -rf ~/.opencode ~/.config/opencode 2>/dev/null
mkdir -p ~/.config
ln -sf /data/opencode ~/.opencode

# 后台定时推送：每 60 秒把数据同步回虚拟主机
(
    while true; do
        sleep 60
        lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" \
            -e "set ssl:verify-certificate no; mirror -R /data/opencode /opencode-data; bye" 2>/dev/null || true
    done
) &

echo "[OpenCode] Starting server..."
opencode web --hostname 0.0.0.0 --port 4096
