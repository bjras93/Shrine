# Start with a lightweight Node.js image to ensure compatibility
FROM node:20-alpine AS base

# Install bash and curl for the Bun installation process
RUN apk add --no-cache bash curl

# Install Bun globally
RUN curl -fsSL https://bun.sh/install | bash

# Set Bun binary in PATH
ENV PATH="/root/.bun/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json bun.lockb ./

# Install dependencies using Bun
RUN bun install

# Copy the rest of the app's code
COPY . .

# Build the Vite app
RUN bun run build

# Use a minimal image for serving the app
FROM nginx:stable-alpine

# Copy built assets to Nginx's default HTML location
COPY --from=base /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
