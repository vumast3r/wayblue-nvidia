#!/usr/bin/env bash
set -euo pipefail

echo "Starting Caelestia Shell pre-requisites..."

# 1. Install Pywal globally using pipx
pipx install pywal --global

# 2. Compile libcava from source (Since Fedora doesn't provide it)
git clone https://github.com/karlstav/cava.git /tmp/cava
cd /tmp/cava
./autogen.sh
./configure --prefix=/usr
make
make install

echo "Compiling Quickshell..."

# 3. Clone and compile Quickshell (master branch)
git clone https://github.com/outfoxxed/quickshell.git /tmp/quickshell
cd /tmp/quickshell
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build
cmake --install build

echo "Building Caelestia Shell..."

# 4. Clone and compile Caelestia
git clone https://github.com/caelestia-dots/shell.git /tmp/caelestia
cd /tmp/caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DINSTALL_QSCONFDIR=/usr/etc/skel/.config/quickshell/caelestia
cmake --build build
cmake --install build

echo "Caelestia Shell successfully installed to image!"
