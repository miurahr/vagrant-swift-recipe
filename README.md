vagrant-swift-recipe
====================

Vagrant recipe for building All in one Swift environment on CentOS/RHEL 6.

works with kvm box

 http://downloads.da-cha.jp/public_file/vagrant-centos-64-kvm.box

difference from ordinal base boxes:
- The image has several partitions for swift data storage
and mount to /srv/1 /srv/2 /srv/3 /srv/4 with XFS.

- to optimize KVM environment, disk drive should be virtio.

This box works with vagrant-kvm plugin.
