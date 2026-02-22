#!/usr/bin/env bash
set -euo pipefail

echo "Starting Caelestia Shell pre-requisites..."

# 1. Install Pywal globally using pipx
pipx install pywal --global

echo "Compiling libcava shared library from source..."

# 2. Compile libcava from the specialized shared library fork
git clone https://github.com/LukashonakV/cava.git /tmp/cava
cd /tmp/cava
meson setup -Dcava_font=false --prefix=/usr build
meson compile -C build
meson install -C build

echo "Compiling Quickshell..."

# 3. Clone and compile Quickshell from the CORRECT Forgejo server
git clone https://git.outfoxxed.me/quickshell/quickshell.git /tmp/quickshell
cd /tmp/quickshell
# Disable jemalloc and the crash reporter to bypass extra dependencies
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DUSE_JEMALLOC=OFF \
      -DCRASH_REPORTER=OFF
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
