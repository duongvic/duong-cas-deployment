FROM golang:1.17.2

LABEL maintainer="Chu Trong Khanh <khanhct@fpt.com.vn>; Pham Son Lam <lamps@fpt.com.vn>"

ENV PBR_VERSION=5.5.1

WORKDIR /home/app

RUN go version
COPY ./cas-order .
RUN go mod tidy
RUN go build -o /usr/local/bin/order-manage ./cmd/manage
RUN go build -o /usr/local/bin/order-api ./cmd/api 
RUN go build -o /usr/local/bin/order-tm ./cmd/taskmanager
