#!/bin/sh

deps_arch="taglib libmpdclient"
deps_rh="libtag1v5 libmpdclient"
deps_suse="fftw3 libmpdclient"
deps_debian="taglib libmpdclient2"
base_dir="/home/$USER/.config/obs-studio/plugins"
plugin_name="tuna"

# Get distro
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    OS=SuSe
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    OS=RedHat
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo "Installing dependencies"
case $OS in
    "Arch Linux" | "Manjaro")
    sudo pacman -S $deps_arch
    ;;
"Debian")
    sudo apt install $deps_debian
    ;;
"SuSe")
    sudo zypper install $deps_suse
    ;;
"RedHat")
    sudo yum install $deps_rh
    ;;
    *)
    echo "Couldn't determine your distro, you will have to install $deps_debian manually"
esac

echo "Uninstalling old plugin"
rm -rf $base_dir/$plugin_name
echo "Installing plugin"
mkdir -p $base_dir
mv ./$plugin_name $base_dir/
