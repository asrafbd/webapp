FROM nginx:1.27-alpine
ENV version=1.0
LABEL maintainer "Asraful Islam"
WORKDIR /usr/share/nginx/html
COPY index.html ./
EXPOSE 80
