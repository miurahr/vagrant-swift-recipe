# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "saio"
  config.vm.network :private_network, ip: "192.168.123.234"
  config.vm.provision :shell, :path=>"bootstrap.sh"
end
