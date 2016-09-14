#!/bin/bash
# Script modified from https://github.com/pypa/python-manylinux-demo
set -e -x

# Install a system package required by our library
# yum -y install wget libaio libaio-devel
#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm
#wget --no-check-certificate https://repo.webtatic.com/yum/el5/x86_64/libmysqlclient15-5.0.95-5.w5.x86_64.rpm
#yum -y --nogpg install libmysqlclient15-5.0.95-5.w5.x86_64.rpm
#wget --no-check-certificate https://repo.webtatic.com/yum/el5/x86_64/libmysqlclient15-devel-5.0.95-5.w5.x86_64.rpm
#yum -y --nogpg install libmysqlclient15-devel-5.0.95-5.w5.x86_64.rpm
#wget --no-check-certificate https://repo.webtatic.com/yum/el5/x86_64/mysql55w-libs-5.5.50-1.w5.x86_64.rpm
#yum -y --nogpg install mysql55w-libs-5.0.95-5.w5.x86_64.rpm
#wget --no-check-certificate https://repo.webtatic.com/yum/el5/x86_64/mysql55w-5.5.50-1.w5.x86_64.rpm
#wget --no-check-certificate https://repo.webtatic.com/yum/el5/x86_64/mysql55w-devel-5.5.50-1.w5.x86_64.rpm
#wget --no-check-certificate https://repo.webtatic.com/yum/el5/x86_64/mysql55w-embedded-5.5.50-1.w5.x86_64.rpm
#wget --no-check-certificate https://repo.webtatic.com/yum/el5/x86_64/mysql55w-embedded-devel-5.5.50-1.w5.x86_64.rpm
#yum install -y --nogpg mysql55w-*.rpm
#yum install -y make python-devel gcc automake  libmysqlclient-devel mysql mysql-devel
yum install -y make gcc python-devel zlib-devel openssl-devel libaio libaio-devel
#wget http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.51.tar.gz/from/http://mysql.he.net/
#tar -zxvf mysql-5.1.51.tar.gz
cd /mysql-5.1.51
CFLAGS=-fPIC CXXFLAGS=-fPIC ./configure 
make install
cd libmysqld
make install
cd /

# Compile wheels
for PYBIN in /opt/python/cp27*/bin; do
    #${PYBIN}/pip install -r /workspace/dev-requirements.txt
    CFLAGS='-g -DUNIV_LINUX -fPIC' ${PYBIN}/pip wheel /workspace/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
#ls wheelhouse/*
for whl in wheelhouse/*linux*.whl; do
    auditwheel repair $whl -w /workspace/wheelhouse/
done

# Install packages and test
#for PYBIN in /opt/python/*/bin/; do
#    ${PYBIN}/pip install librabbitmq -f /workspace/wheelhouse
#    ${PYBIN}/python -c "import librabbitmq"
#    #(cd $HOME; ${PYBIN}/nosetests pymanylinuxdemo)
#done
