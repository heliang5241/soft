#!/bin/bash
CHECK_RUN()
{
if [ "$?" = "0" ]; then
  echo "=============== Run [$1] succeed! ==============="
  sleep 3
else
  echo "[$1] install Error, abort!"
  exit 2
fi
}

yum -y install xz wget gcc make gdbm-devel openssl-devel sqlite-devel zlib-devel bzip2-devel
work_dir=/root/source
mkdir -p $work_dir
cd $work_dir
wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz --no-check-certificate
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-7.0.tar.gz --no-check-certificate
wget https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz --no-check-certificate
wget http://pyyaml.org/download/libyaml/yaml-0.1.5.tar.gz --no-check-certificate
wget https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz --no-check-certificate
wget https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.9.3.tar.gz --no-check-certificate
wget https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz --no-check-certificate
wget https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz --no-check-certificate
wget https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.1.tar.gz --no-check-certificate
wget https://pypi.python.org/packages/source/s/simplejson/simplejson-3.6.5.tar.gz --no-check-certificate
wget -O ansible-1.7.2.tar.gz https://github.com/ansible/ansible/archive/v1.7.2.tar.gz --no-check-certificate
count=`ls -l|grep '-'|wc -l`
if [ $count -ne 11 ];then
    echo "count is not correct,exit"
    exit
fi
if [ -f setup.log ];then
rm -rf setup.log
fi
tar zxvf Python-2.7.8.tgz
cd Python-2.7.8
./configure --enable-shared --enable-loadable-sqlite-extensions --with-zlib
make
make install
mv /usr/bin/python /usr/bin/python2.6.6
ln -s /usr/local/bin/python2.7 /usr/bin/python
echo -e "/usr/local/lib" >>/etc/ld.so.conf
/sbin/ldconfig
/sbin/ldconfig -v
sed -i 's@#!/usr/bin/python@#!/usr/bin/python2.6.6@' /usr/bin/yum
python -V
CHECK_RUN "python_install" >>setup.log

cd $work_dir
tar xvzf setuptools-7.0.tar.gz
cd setuptools-7.0
python setup.py install
CHECK_RUN "setuptools_install" >>setup.log

cd $work_dir
tar xvzf pycrypto-2.6.1.tar.gz
cd pycrypto-2.6.1
python setup.py install
CHECK_RUN "pycrypto_install" >>setup.log

cd $work_dir
tar xvzf yaml-0.1.5.tar.gz
cd yaml-0.1.5
./configure --prefix=/usr/local
make --jobs=`grep processor /proc/cpuinfo | wc -l`
make install
CHECK_RUN "yaml_instll" >>setup.log

cd $work_dir
tar xvzf PyYAML-3.11.tar.gz
cd PyYAML-3.11
python setup.py install
CHECK_RUN "PyYAML_install" >>setup.log

cd $work_dir
tar xvzf MarkupSafe-0.9.3.tar.gz
cd MarkupSafe-0.9.3
python setup.py install
CHECK_RUN "MarkupSafe_install" >>setup.log

cd $work_dir
tar xvzf Jinja2-2.7.3.tar.gz
cd Jinja2-2.7.3
python setup.py install
CHECK_RUN "Jinja_install" >>setup.log

cd $work_dir
tar xvzf ecdsa-0.11.tar.gz
cd ecdsa-0.11
python setup.py install
CHECK_RUN "ecdsa_install" >>setup.log

cd $work_dir
tar xvzf paramiko-1.15.1.tar.gz
cd paramiko-1.15.1
python setup.py install	
CHECK_RUN “paramiko_install” >>setup.log

cd $work_dir
tar xvzf simplejson-3.6.5.tar.gz
cd simplejson-3.6.5
python setup.py install
CHECK_RUN “simplejson_install” >>setup.log

cd $work_dir
mv v1.7.2.tar.gz ansible-1.7.2.tar.gz
tar xvzf ansible-1.7.2.tar.gz
cd ansible-1.7.2
python setup.py install
CHECK_RUN "ansible_install" >>setup.log
