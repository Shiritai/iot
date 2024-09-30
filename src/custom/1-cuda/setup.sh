#!/bin/bash

echo "export CUDA_PATH=/usr/local/cuda" >> ~/.bashrc
echo "export PATH=/usr/local/cuda/bin:\${PATH}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\${LD_LIBRARY_PATH}" >> ~/.bashrc

echo "export CUDA_PATH=/usr/local/cuda" >> ~/.zshrc
echo "export PATH=/usr/local/cuda/bin:\${PATH}" >> ~/.zshrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\${LD_LIBRARY_PATH}" >> ~/.zshrc
