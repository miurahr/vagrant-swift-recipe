#!/bin/sh
#
VAGRANT_ROOT=/vagrant
#
rpm -i ${VAGRANT_ROOT}/repos/epel-release-6-8.noarch.rpm
yum -y install curl gcc memcached rsync sqlite xfsprogs git-core xinetd python-setuptools
yum -y install python-coverage python-devel python-nose python-simplejson python-xattr python-eventlet python-greenlet python-pastedeploy python-netifaces python-pip python-dnspython python-mock
yum -y install openstack-swift openstack-swift-proxy openstack-swift-object openstack-swift-container openstack-swift-account
#
mkdir -p /etc/swift/object-server /etc/swift/container-server /etc/swift/account-server /srv/1/node/sdb1 /srv/2/node/sdb2 /srv/3/node/sdb3 /srv/4/node/sdb4 /var/run/swift
chown -R vagrant:vagrant /etc/swift /srv/[1-4]/ /var/run/swift 
#
cat <<__RC_LOCAL__ > /etc/rc.local
#!/bin/sh
touch /var/lock/subsys/local

mkdir -p /var/cache/swift /var/cache/swift2 /var/cache/swift3 /var/cache/swift4
chown vagrant:vagrant /var/cache/swift*
mkdir -p /var/run/swift
chown vagrant:vagrant /var/run/swift

exit 0
__RC_LOCAL__

#
service memcached start
chkconfig memcached on
#
# Puppet: edit the following line in /etc/xinetd.d/rsync:
#
# disable = no

cp ${VAGRANT_ROOT}/conf/rsyslog/* /etc/rsyslog/
#
# Puppet: Edit /etc/rsyslog.conf and make the following change:
#
# $PrivDropToGroup adm
#
mkdir -p /var/log/swift/hourly
chown -R syslog.adm /var/log/swift
chmod -R g+w /var/log/swift
#
# Puppet:
#  service xinetd. restart
#  service rsyslog restart
#
cp -r ${VAGRANT_ROOT}/conf/swift/* /etc/swift/
#find /etc/swift/ -name \*.conf | xargs sed -i "s/<your-user-name>/${USER}/"
#
mkdir -p /usr/local/bin/
cp ${VAGRANT_ROOT}/bin/* /usr/local/bin/
chmod +x /usr/local/bin/*
#
cat <<__BASHRC__ >> /home/vagrant/.bashrc
export SWIFT_TEST_CONFIG_FILE=/etc/swift/test.conf
export PATH=${PATH}:/usr/local/bin
__BASHRC__

