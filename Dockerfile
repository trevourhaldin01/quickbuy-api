FROM node:20-alpine AS builder

WORKDIR /app

# Copy root package files
COPY package.json package-lock.json  ./

# Copy server package file (if it exists)
# COPY apps/server/package.json ./apps/server/

# Install all dependencies
RUN npm ci

# Copy entire project
COPY . .

# Build server
RUN npm run build

# ============================================
# Production stage
# ============================================
FROM node:20-alpine

WORKDIR /app

# Install production dependencies only
COPY package.json package-lock.json ./
# COPY apps/server/package.json ./apps/server/

RUN npm ci 

# Copy built application
COPY --from=builder /app/dist ./dist

# Copy the dashboard build from the directory (new location)
# COPY  apps/server/public/dashboard ./apps/server/dist/dashboard

# Copy dashboard build if you have one
# COPY --from=builder /app/apps/dashboard/dist ./apps/dashboard/dist

# Create necessary directories
RUN mkdir -p /data/assets

# Expose port
EXPOSE 3000

# Set environment
ENV NODE_ENV=production

# Work in server directory
WORKDIR /app

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget -qO- http://localhost:3000/health > /dev/null || exit 1
# Start application
CMD ["node", "dist/index.js"]

