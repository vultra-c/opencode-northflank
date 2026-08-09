FROM node:20-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN curl -fsSL https://opencode.ai/install | bash
ENV PATH="/root/.local/bin:/usr/local/bin:${PATH}"

RUN mkdir -p /data/opencode
WORKDIR /app

EXPOSE 4096

CMD ["sh", "-c", \
    "mkdir -p /data/opencode && \
     rm -rf ~/.opencode ~/.config/opencode 2>/dev/null; \
     ln -sf /data/opencode ~/.opencode && \
     opencode web --hostname 0.0.0.0 --port 4096"]
