#
# puppet module for all-in-one swift
#
class swift {

$dependency = [
  "memcached","rsync","sqlite","xfsprogs","xinetd","rsyslog",
  "python-coverage","python-devel",
  "python-nose","python-simplejson",
  "pyxattr","python-eventlet",
  "python-greenlet","python-paste-deploy","python-netifaces",
  "python-pip","python-dns","python-mock"]
$swiftpkgs = [ "openstack-swift","openstack-swift-proxy",
  "openstack-swift-object",
  "openstack-swift-container",
  "openstack-swift-account"]

package {
  $dependency:
   ensure  => "installed",
}
package {
  $swiftpkgs:
   ensure  => "installed",
}

service { 'memcached':
  require => Package["memcached"],
  ensure => 'running',
  enable => 'true',
}
service { 'rsyslog':
  require => Package["rsyslog"],
  ensure => 'running',
  enable => 'true',
}

file {"/etc/rsyslog.d/10-swift.conf":
  content => template("swift/rsyslog.conf"),
  notify => Service['rsyslog'],
  require => Package["rsyslog"],
  ensure => "present",
  owner => "root",
  group => "root"
}
file {"/etc/rsyncd.conf":
  content => template("swift/rsyncd.conf"),
  ensure => "present",
  owner => "root",
  group => "root",
}
file {
 "/var/log/swift":
    ensure => "directory",
    owner  => "swift",
    group  => "adm",
    mode   => 770;
 "/var/log/swift/hourly":
    ensure => "directory",
    owner  => "swift",
    group  => "adm",
    mode   => 770;
}

file {
 ["/etc/swift",
 "/etc/swift/object-server",
 "/etc/swift/container-server",
 "/etc/swift/account-server"]:
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755;
}
file {
 "/etc/swift/proxy-server.conf":
    content => template("swift/proxy-server.conf"),
    require => File["/etc/swift"],
    owner   => "root",
    group   => "root",
    mode    => 644;
 "/etc/swift/swift.conf":
    content => template("swift/swift.conf"),
    require => File["/etc/swift"],
    owner   => "root",
    group   => "root",
    mode    => 644;
}
file {
 "/etc/swift/account-server/1.conf":
    content => template("swift/account-server/1.conf");
 "/etc/swift/account-server/2.conf":
    content => template("swift/account-server/2.conf");
 "/etc/swift/account-server/3.conf":
    content => template("swift/account-server/3.conf");
 "/etc/swift/account-server/4.conf":
    content => template("swift/account-server/4.conf");
}
file {
 "/etc/swift/container-server/1.conf":
    content => template("swift/container-server/1.conf");
 "/etc/swift/container-server/2.conf":
    content => template("swift/container-server/2.conf");
 "/etc/swift/container-server/3.conf":
    content => template("swift/container-server/3.conf");
 "/etc/swift/container-server/4.conf":
    content => template("swift/container-server/4.conf");
}
file {
 "/etc/swift/object-server/1.conf":
    content => template("swift/object-server/1.conf");
 "/etc/swift/object-server/2.conf":
    content => template("swift/object-server/2.conf");
 "/etc/swift/object-server/3.conf":
    content => template("swift/object-server/3.conf");
 "/etc/swift/object-server/4.conf":
    content => template("swift/object-server/4.conf");
}

file {
 "/srv":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755
}

file {
 ["/var/cache/swift",
  "/var/cache/swift2",
  "/var/cache/swift3",
  "/var/cache/swift4"]:
  require => Package["openstack-swift"],
  owner  => "swift",
  group  => "swift",
  ensure => "directory",
  mode   => 750
}

file { "/var/run/swift":
  require => Package["openstack-swift"],
  owner  => "swift",
  group  => "swift",
  ensure => "directory",
  mode   => 750
}

file {
  ["/srv/1/node","/srv/1/node/sdb1"]:
  require => Package["openstack-swift"],
  owner  => "swift",
  group  => "swift",
  ensure => "directory",
  mode   => 750
}
file {
  ["/srv/2/node","/srv/2/node/sdb2"]:
  require => Package["openstack-swift"],
  owner  => "swift",
  group  => "swift",
  ensure => "directory",
  mode   => 750
}
file {
  ["/srv/3/node","/srv/3/node/sdb3"]:
  require => Package["openstack-swift"],
  owner  => "swift",
  group  => "swift",
  ensure => "directory",
  mode   => 750
}
file {
  ["/srv/4/node","/srv/4/node/sdb4"]:
  require => Package["openstack-swift"],
  owner  => "swift",
  group  => "swift",
  ensure => "directory",
  mode   => 750
}

file {"/usr/local/bin":
  ensure => "directory",
  mode   => 755,
}

file { "/usr/local/bin/remakerings":
  require => File["/usr/local/bin"],
  content => template("swift/remakerings"),
  ensure => "present",
  owner => "root",
  group => "root",
  mode  => 755
}

exec { "create_ring_files":
   require => File["/usr/local/bin/remakerings"],
   command => "/usr/local/bin/remakerings",
   path    => "/usr/local/bin:/usr/bin",
   creates => ["/etc/swift/account.ring.gz", "/etc/swift/container.ring.gz", "/etc/swift/object.ring.gz"]
}

file {'/etc/swift/account.ring.gz':
    require => Exec["create_ring_files"],
    ensure => 'present'
}
file {'/etc/swift/container.ring.gz':
    require => Exec["create_ring_files"],
    ensure => 'present'
}
file {'/etc/swift/object.ring.gz':
    require => Exec["create_ring_files"],
    ensure => 'present'
}

file {"/tmp/openstack-swift-prerequisite":
  require => File [
   '/etc/swift/swift.conf',
   '/etc/swift/proxy-server.conf',
   '/etc/swift/object.ring.gz',
   '/etc/swift/container.ring.gz',
   '/etc/swift/account.ring.gz',
   '/srv/2/node', '/etc/swift/object-server/4.conf',
   '/srv/3/node', '/etc/swift/account-server/4.conf',
   '/srv/4/node', '/etc/swift/container-server/4.conf',
   '/var/cache/swift4'],
  ensure   => "present",
  content => template("swift/stamp")
}

service { 
 'openstack-swift-account':
   require => File ['/tmp/openstack-swift-prerequisite'],
   ensure => 'running',
   enable => 'true';
 'openstack-swift-container':
   require => File ['/tmp/openstack-swift-prerequisite'],
   ensure => 'running',
   enable => 'true';
 'openstack-swift-object':
   require => File ['/tmp/openstack-swift-prerequisite'],
   ensure => 'running',
   enable => 'true';
 'openstack-swift-proxy':
   require => File ['/tmp/openstack-swift-prerequisite'],
   ensure => 'running',
   enable => 'true';
}
} # eod of class decraration
