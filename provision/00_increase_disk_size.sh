#!/bin/bash
echo -e "\n################################################"
echo "extending the root partition..."
echo -e ", +\ny" | sudo sfdisk -N 3 /dev/sda --force
sudo partx -u /dev/sda
sudo btrfs filesystem resize max /
echo -e "root partion extended.\n"