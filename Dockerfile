FROM node:18-alpine
WORKDIR /build
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN export NODE_OPTIONS=--openssl-legacy-provider && npm run prod-pack
ENTRYPOINT ["cp", "-r", "./build", "./releases/"]
