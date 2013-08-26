#
# Vagrant provision puppet recipe for all-in-one swift
#

stage { 'yum' : before => Stage['main'] }
stage { 'pre' : before => Stage['yum'] }

class fedora-grizzly-repo {
  yumrepo { "fedora-openstack-grizlly":
    descr     => 'OpenStack Grizzly Repository for Fedora',
    baseurl   => 'http://repos.fedorapeople.org/repos/openstack/openstack-grizzly/fedora-$releasever/',
    failovermethod => "priority",
    enabled   => 1,
    gpgcheck  => 0,
    skip_if_unavailable => 1,
  }
}

class epel-grizlly-repo {
  yumrepo { "epel-openstack-grizlly":
    descr     => 'OpenStack Grizzly Repository for EPEL 6',
    baseurl   => 'http://repos.fedorapeople.org/repos/openstack/openstack-grizzly/epel-6',
    failovermethod => "priority",
    enabled   => 1,
    gpgcheck  => 0,
    priority  => 98,
  }

}

class epel-repo {
  yumrepo { "epel":
    descr    => 'Extra Packages for Enterprise Linux 6',
    #baseurl  => 'http://download.fedoraproject.org/pub/epel/6/$basearch',
    mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
    failovermethod => "priority",
    enabled  => 1,
    gpgcheck => 0,
  }
}

class yum-proxy {
  augeas { 'yum.conf':
      context => "/files/etc/yum.conf/main",
      changes => [
        "set proxy http://proxy:8080/" ,
	"set proxy_username username",
	"set proxy_password password",
      ],
  }
}

node default {
  # if you need proxy, enable follows
  #class { 'yum-proxy': stage => pre }

  # Choose from several alternative repositories
  #
  class {'epel-repo': stage => yum }
  # class {'fedora-grizlly-repo': stage => yum}
  class {'epel-grizlly-repo': stage => yum}
 
  include swift
  include develpkg
}

class develpkg {
  $develpkgs = ["curl","gcc","git","python-setuptools"]
  package { $develpkgs: ensure => "installed" }
}
