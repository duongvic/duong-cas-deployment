FROM python:3.8.5-slim-buster

LABEL maintainer="Chu Trong Khanh <khanhct@fpt.com.vn>"

RUN apt-get update -y
RUN apt-get install -y libmemcached-dev zlib1g-dev

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc
  
RUN apt-get install python3-pymysql -y 

RUN apt-get install libsasl2-dev python-dev libldap2-dev libssl-dev -y
RUN python -m pip install --upgrade pip
RUN pip3 install pymysql
RUN pip3 install python-memcached
RUN pip3 install etcd3gw

RUN apt-get install wget -y
RUN wget https://github.com/Graylog2/collector-sidecar/releases/download/1.0.2/graylog-sidecar_1.0.2-1_amd64.deb
RUN dpkg -i ./graylog-sidecar_1.0.2-1_amd64.deb
RUN apt-get update -y
RUN apt-get install graylog-sidecar -y
COPY ./sidecar.yml /etc/graylog/sidecar/
COPY ./graylog-sidecar.service /etc/systemd/system/
RUN graylog-sidecar -service install
RUN service graylog-sidecar restart

WORKDIR /tmp/lib
COPY ./shade .
RUN python setup.py install
RUN rm -rf *

COPY ./cephclient .
RUN python setup.py install
RUN rm -rf *

RUN mkdir /etc/cas/
RUN mkdir /var/log/cas/
RUN touch /var/log/cas/api.log & touch /var/log/cas/tm.log