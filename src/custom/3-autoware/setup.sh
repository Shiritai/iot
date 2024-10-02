#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname $0))

print_info "Prepare environment for compiling utoware"

install_if_dne python3.10-venv apt-utils

echo "export PATH=\$PATH:/home/shiritai/.local/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/home/shiritai/.local/bin" >> ~/.zshrc
source ~/.bashrc

print_info "Setup ccache..."

mkdir -p ~/.cache/ccache
touch ~/.cache/ccache/ccache.conf
echo "max_size = 60G" >> ~/.cache/ccache/ccache.conf

echo "export CUDACXX=/usr/local/cuda/bin/nvcc" >> ~/.bashrc
echo "export CC=/usr/lib/ccache/gcc" >> ~/.bashrc
echo "export CXX=/usr/lib/ccache/g++" >> ~/.bashrc
echo "export CCACHE_DIR=\${HOME}/.cache/ccache/" >> ~/.bashrc

echo "export CUDACXX=/usr/local/cuda/bin/nvcc" >> ~/.zshrc
echo "export CC=/usr/lib/ccache/gcc" >> ~/.zshrc
echo "export CXX=/usr/lib/ccache/g++" >> ~/.zshrc
echo "export CCACHE_DIR=\${HOME}/.cache/ccache/" >> ~/.zshrc

print_info "Setup ccache successfully"

print_info "Autoware compilation environment is now set"

${SCRIPT_DIR}/compile.sh ~
