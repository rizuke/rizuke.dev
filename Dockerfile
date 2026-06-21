FROM ghcr.io/rizuke/devcontainers/node-pnpm:latest AS builder

USER root
RUN mkdir -p /app && chown node:node /app
USER node

WORKDIR /app

COPY --chown=node:node package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile

COPY --chown=node:node . .
RUN pnpm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80