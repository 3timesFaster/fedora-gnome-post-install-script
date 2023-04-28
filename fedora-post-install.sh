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
	libreoffice-core \
	gnome-boxes
	
# Dnf firmware and multimedia 
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
       	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
	rpmfusion-nonfree-release-tainted \
	gnome-tweaks
dnf groupupdate core \
	multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin \
	sound-and-video
dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

# Gnome extensions
flatpak install flathub com.mattjakeman.ExtensionManager 

# update
dnf update -y

# Check if Intel integrated graphics card is present
if lspci -vnn | grep VGA | grep -iq "intel"; then
    echo "Intel integrated graphics detected. Installing intel-media-driver."
    sudo dnf install intel-media-driver
# Check if Nvidia graphics card is present
elif lspci -vnn | grep VGA | grep -iq "nvidia"; then
    echo "Nvidia graphics card detected. Installing nvidia-vaapi-driver."
    sudo dnf install nvidia-vaapi-driver
    echo "Remember to use the Howto/Nvidia page on the RPM fuision site to install the proprietary drivers"
    echo "https://rpmfusion.org/Howto/NVIDIA?highlight=%28%5CbCategoryHowto%5Cb%29"
else
    echo "No supported graphics card detected. or its an AMD which means your good."
fi
