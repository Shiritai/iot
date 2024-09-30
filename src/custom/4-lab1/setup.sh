#!/bin/bash

echo "export PATH=$PATH:/home/shiritai/.local/bin" >> ~/.bashrc
echo "export PATH=$PATH:/home/shiritai/.local/bin" >> ~/.zshrc

pip install gdown
. ~/.bashrc
. ~/.zshrc

gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1499_nsbUbIeturZaDj7jhUownh5fvXHd'
unzip -d ~/autoware_map ~/autoware_map/sample-map-planning.zip
