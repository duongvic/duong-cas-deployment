FROM node:14.15.4-buster-slim as builder

LABEL maintainer="Chu Trong Khanh <khanhct@fpt.com.vn>"

RUN apt-get update -y
# install system dependencies
RUN apt-get update 

WORKDIR /app
COPY ./cas-fe /app/


RUN npm install

RUN npm run build

FROM nginx:1.17-alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY ./default.conf /etc/nginx/conf.d/default.conf