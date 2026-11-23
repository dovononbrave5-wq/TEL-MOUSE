# Étape 1 : compiler robotjs (module natif)
FROM node:20-bookworm AS construction
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 make g++ libxtst-dev libpng-dev libx11-dev \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# Étape 2 : image finale, sans les outils de compilation
FROM node:20-bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
      libxtst6 libpng16-16 libx11-6 \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=construction /app/node_modules ./node_modules
COPY . .
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "src/server.js"]