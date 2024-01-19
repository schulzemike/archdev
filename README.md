# My Arch dev-machine
My vagrant playground for a new dev machine based on arch

Virtualbox-Image based on the official released vagrant basebox. For more information see:  
- [archlinux download page](https://archlinux.org/download/)
- [vagrant Cloud page](https://app.vagrantup.com/archlinux/boxes/archlinux)

## Setup
- create a new folder and run `vagrant init archlinux/archlinux`
- adjust the created Vagrantfile to your needs

## increase the disk size to be greater than the initial 20GB

1) add this line to the Vagrantfile: `config.vm.disk :disk, size: "45GB", primary: true`
2) (opt) Check the disksize inside the machine via `lsblk`
