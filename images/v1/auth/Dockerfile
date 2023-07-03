FROM reg.fptcompute.com.vn/dev/caspython:0.1

LABEL maintainer="Chu Trong Khanh <khanhct@fpt.com.vn>"

ENV PBR_VERSION=5.5.1

WORKDIR /home/app

RUN pip3 --version
COPY ./cas-auth-api .
RUN pip install -r requirements.txt
RUN python3 setup.py install
RUN cp -rf ./etc/* /etc/cas
