#!/usr/bin/bash

# Check if running with sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges" 
   exit 1
fi 

# Makes dnf faster
# Check if max_parallel_downloads is already set to 10
if grep -q "^max_parallel_downloads=10$" /etc/dnf/dnf.conf; then
    echo "max_parallel_downloads is already set to 10"
else
    # Add max_parallel_downloads=10 to the end of the file
    echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
    echo "max_parallel_downloads has been set to 10"
fi

# Check if fastmirror is already set to True
if grep -q "^fastmirror=True$" /etc/dnf/dnf.conf; then
    echo "fastmirror is already set to True"
else
    # Add fastmirror=True to the end of the file
    echo "fastmirror=True" >> /etc/dnf/dnf.conf
    echo "fastmirror has been set to True"
fi

# update
dnf update -y

# remove junk from workstation
dnf remove -y gnome-connections \
	anaconda \
	gnome-characters \
	gnome-classic-session \
	gnome-contacts \
	gnome-maps \
	gnome-photos \
	gnome-remote-desktop \
	gnome-system-monitor \
	gnome-tour \
	gnome-user-docs \
	yelp \
	cheese \
	rhythmbox \
	totem \
	libreoffice-core

