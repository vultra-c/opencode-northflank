FROM node:20-slim

RUN apt-get update && apt-get install -y \
    curl git build-essential python3 ca-certificates lftp \
    && rm -rf /var/lib/apt/lists/*

# 安装 opencode，并创建符号链接到 /usr/local/bin（标准 PATH）
RUN curl -fsSL https://opencode.ai/install | bash && \
    ln -sf /root/.local/bin/opencode /usr/local/bin/opencode

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 4096
CMD ["/app/start.sh"]
