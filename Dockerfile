# Stage 1: compilación de React con Vite
# Las variables VITE_API_* se pasan en tiempo de BUILD (no runtime).
# Vite las incrusta en el bundle JS compilado.
FROM node:20-alpine AS builder

ARG VITE_API_VENTAS
ARG VITE_API_DESPACHOS

ENV VITE_API_VENTAS=$VITE_API_VENTAS
ENV VITE_API_DESPACHOS=$VITE_API_DESPACHOS

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: servidor Nginx con los estáticos compilados
FROM nginx:alpine AS runner
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
