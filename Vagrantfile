# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "saio"
  config.vm.network :private_network, ip: "192.168.123.234"

  config.vm.provision :puppet do |puppet|
     puppet.options = "--verbose"
     puppet.manifests_path = "manifests"
     puppet.manifest_file = "site.pp"
     puppet.module_path = "modules"
  end
end
