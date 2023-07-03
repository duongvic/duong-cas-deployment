FROM centos:7

LABEL maintainer="Trinh Dinh tuan <tuantd16@fpt.com.vn>"

WORKDIR /cas-backup

RUN yum clean all && rm -rf /var/cache/yum/
RUN yum -y install epel-release

COPY ./cas-backup .
COPY ceph.repo /etc/yum.repos.d/

RUN yum -y install ceph-common zip unzip git python3 python3-devel gcc gcc-c++ make libpqxx libpqxx-devel supervisor librados-devel librbd-devel

RUN pip3 install git+https://github.com/ceph/ceph@v$(ceph -v | awk '{print $3}')#subdirectory=src/pybind/rados
RUN pip3 install git+https://github.com/ceph/ceph@v$(ceph -v | awk '{print $3}')#subdirectory=src/pybind/rbd
RUN pip3 install git+https://github.com/khanhct/shade.git@dev#egg=shade

RUN pip3 install -r src/requirements.txt
RUN python3 setup.py install

RUN mkdir /etc/cas
RUN cp ./etc/benji-minimal.yaml /etc/cas/benji.yaml
RUN mkdir -p /var/log/backup
