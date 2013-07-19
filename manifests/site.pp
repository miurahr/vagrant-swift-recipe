#
# Vagrant provision puppet recipe for all-in-one swift
#

stage { 'yum' : before => Stage['main'] }

class repo {

  yumrepo { "epel":
    descr    => 'Extra Packages for Enterprise Linux 6',
    #baseurl  => 'http://download.fedoraproject.org/pub/epel/6/$basearch',
    mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
    failovermethod => "priority",
    enabled  => 1,
    gpgcheck => 0,
  }
}

node default {
  class { 'repo': stage => yum }
  include swift
}

$develpkgs = ["curl","gcc","git","python-setuptools"]
package { $develpkgs: ensure => "installed" }
