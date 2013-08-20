
class yumconf {
  define proxy ( 
    $proxy ="",
    $proxy_username = nil, 
    $proxy_password = nil
  ) {

    case $operatingsystem {
        centos: {
          $distroverpkg='centos-release'
        }
        redhat: {
          $distroverpkg='redhat-release'
        }
    }

    file { '/etc/yum.conf':
      content => template('yumconf/yum.conf.erb'),
    }
  }
}
