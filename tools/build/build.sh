#!/bin/sh

#Detect OS and use corresponding package manager for dependencies. Currently only works for arch, debian/ubuntu, and RHEL/fedora/CentOS
if [[ -f '/etc/arch-release' ]]; then
  echo -ne '\n y' | sudo pacman --needed -Sy base-devel git curl nodejs unzip
fi
if [[ -f '/etc/debian version' ]]; then
  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get install -y build-essential git curl lib32z1 pkg-config libssl-dev:i386 libssl-dev nodejs unzip g++-multilib libc6-i386 libstdc++6:i386
fi
if [[ -f '/etc/centos-release' ]] || [[ -f '/etc/fedora-release' ]]; then #DNF should work for both of these
  sudo dnf --refresh install make automake gcc gcc-c++ kernel-devel git curl unzip glibc-devel.i686 openssl-devel.i686 libgcc.i686 libstdc++-devel.i686
fi

cd binaries

#Install rust if not present
if ! [ -x "$has_cargo" ]; then
	echo "Installing rust..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	. ~/.profile
fi

#Download/update rust-g repo
if [ ! -d "rust-g" ]; then
	echo "Cloning rust-g..."
	git clone https://github.com/tgstation/rust-g
	cd rust-g
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
else
	echo "Fetching rust-g..."
	cd rust-g
	git fetch
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
fi

#Compile and move rust-g binary to repo root
echo "Deploying rust-g..."
git checkout "$RUST_G_VERSION"
env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo build --release --target=i686-unknown-linux-gnu
mv target/i686-unknown-linux-gnu/release/librust_g.so ../../../../librust_g.so
cd ..

#Download/update auxmos repo
if [ ! -d "auxmos" ]; then
	echo "Cloning auxmos..."
	git clone https://github.com/Putnam3145/auxmos
	cd auxmos
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
else
	echo "Fetching auxmos..."
	cd auxmos
	git fetch
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
fi

#Compile and move auxmos binary to repo root
echo "Deploying auxmos..."
git checkout "$AUXMOS_VERSION"
env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo build --release --target=i686-unknown-linux-gnu
mv target/i686-unknown-linux-gnu/release/libauxmos.so ../../../../libauxmos.so
cd ../..

#Install BYOND
cd ../..
./tools/ci/install_byond.sh
source $HOME/BYOND/byond/bin/byondsetup

cd tools/build

#Build TGUI
set -e
cd "$(dirname "$0")"
exec ../bootstrap/node build.js "$@"
