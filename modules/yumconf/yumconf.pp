
class yumconf ($proxy, $proxy_username, $proxy_password) {

  if !defined?($proxy)
     $proxy_username=nil 
     $proxy_password=nil
  end
  if !defined?($proxy_username)
     $proxy_password=nil
  end

  case $operatingsystem {
        centos: {
          $distroverpkg='centos-release'
        }
        redhat: {
          $distroverpkg='redhat-release'
        }
      }


  file { '/etc/yum.conf':
    content        => template('yum.conf.erb'),
  }

}
