#!/bin/bash
yum -y install xz wget gcc make gdbm-devel openssl-devel sqlite-devel zlib-devel bzip2-devel
mkdir -p /root/source
cd /root/source
wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-7.0.tar.gz
wget https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz
wget http://pyyaml.org/download/libyaml/yaml-0.1.5.tar.gz
wget https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz
wget https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.9.3.tar.gz
wget https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz
wget https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz
wget https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.1.tar.gz
wget https://pypi.python.org/packages/source/s/simplejson/simplejson-3.6.5.tar.gz
wget https://github.com/ansible/ansible/archive/v1.7.2.tar.gz
tar zxvf tar zxvf Python-2.7.8.tgz
cd Python-2.7.8
./configure --enable-shared --enable-loadable-sqlite-extensions --with-zlib
make
make install
mv /usr/bin/python /usr/bin/python2.6.6
ln -s /usr/local/bin/python2.7 /usr/bin/python
echo -e "/usr/local/lib" >>/etc/ld.so.conf
/sbin/ldconfig
/sbin/ldconfig -v

