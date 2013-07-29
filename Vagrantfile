# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "base"

  # for virtualbox.
  #config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box

  # for AWS
  #config.vm.box = "dummy"
  #config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  # for KVM
  #config.vm.box_url = "http://downloads.da-cha.jp/public_file/vagrant-centos-64-kvm.box"

  config.vm.network :private_network, ip: "192.168.123.234"
  config.vm.network :forward_port, guest: 8080, host: 12345, auto_correct: true

  config.ssh.timeout   = 500
  config.ssh.max_tries = 100

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provider :kvm do |kvm|
  end

  config.vm.provider :aws do |aws|
    aws.region = "ap-north-1"
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = "vagrant"
    aws.ssh_private_key_path = "~/.ssh/aws/vagrant.pem"
    aws.ami = "ami-7747d01e"
    aws.ssh_username = "ubuntu"
  end

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.manifest_file = "site.pp"
     puppet.module_path = "modules"
  end
end
