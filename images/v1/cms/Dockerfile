FROM node:14.16.0-buster-slim as builder

LABEL maintainer="Chu Trong Khanh <khanhct@fpt.com.vn>"

RUN apt-get update -y
WORKDIR /app
COPY ./cas-cms-landing-dashboard /app/

RUN yarn install

RUN yarn build

EXPOSE 1337

CMD ['yarn', 'start']
