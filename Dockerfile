FROM node:20-slim

RUN apt-get update && apt-get install -y \
    curl git build-essential python3 ca-certificates lftp \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://opencode.ai/install | bash
ENV PATH="/root/.local/bin:/usr/local/bin:${PATH}"

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 4096
CMD ["/app/start.sh"]
