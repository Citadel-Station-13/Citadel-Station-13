#!/bin/bash

./InstallDeps.sh

#load dep exports
#need to switch to game dir for Dockerfile weirdness
original_dir=$PWD
cd "$1"
. dependencies.sh
cd "$original_dir"


# update rust-g
if [ ! -d "rust-g" ]; then
	echo "Cloning rust-g..."
	git clone https://github.com/Citadel-Station-13/rust-g
	cd rust-g
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
else
	echo "Fetching rust-g..."
	cd rust-g
	git fetch
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
fi

echo "Deploying rust-g..."
git checkout "$RUST_G_VERSION"
env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo build --ignore-rust-version --release --target=i686-unknown-linux-gnu --features=all
cp -f target/i686-unknown-linux-gnu/release/librust_g.so "$1/librust_g.so"
cd ..

# Update auxmos
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

echo "Deploying auxmos..."
git checkout "$AUXMOS_VERSION"
env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo rustc --release --target=i686-unknown-linux-gnu --features "all_reaction_hooks katmos" -- -C target-cpu=native
mv -f target/i686-unknown-linux-gnu/release/libauxmos.so "$1/libauxmos.so"
cd ..

# compile tgui
echo "Compiling tgui..."
cd "$1"
chmod +x tools/bootstrap/node  # Workaround for https://github.com/tgstation/tgstation-server/issues/1167
env TG_BOOTSTRAP_CACHE="$original_dir" TG_BOOTSTRAP_NODE_LINUX=1 CBT_BUILD_MODE="TGS" tools/bootstrap/node tools/build/build.js
