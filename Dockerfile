# 1. Baixa a imagem oficial do Nginx
FROM nginx:1.29.7-alpine-slim

# 2. Copia tudo que está na pasta /src para a pasta padrão Nginx
COPY ./src /usr/share/nginx/html

# 3. Comunicação pela porta 80
EXPOSE 80