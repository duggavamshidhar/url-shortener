# syntax=docker/dockerfile:1.0

FROM node:22-alpine AS base

# Install dependencies
FROM base AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --production

# Production stage
FROM base AS runner

WORKDIR /app

RUN adduser --system --uid 1001 admin

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json
COPY ./src ./src 

RUN chown -R admin /app

USER admin

EXPOSE 5500

CMD ["npm", "run", "start"]
