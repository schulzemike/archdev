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
```
# show unallocated diskspace of a disk
sudo sfdisk --list-free /dev/sda
```
sgdisk -e /dev/sda


# Partition manuell erweitern


# sudo pacman -S parted --noconfirm
# Anzeige: parted -s /dev/sda "print free"
# tried this with GNU parted 3.6 - ---prepend-input-tty is not documented
# echo -e "yes\n" | sudo parted ---pretend-input-tty -f -a opt /dev/sda resizepart 3 100%


echo -e ", +\ny" | sudo sfdisk -N 3 /dev/sda --force
sudo partx -u /dev/sda
sudo btrfs filesystem resize max /