#! /bin/sh

# Run as root!
# This script is start as new server.

apt update && apt upgrade -y 

# Install dependence software.  

apt install -y wget curl git 

# Python something dependence software
apt install -y --no-install-recommends \
    make build-essential libssl-dev zlib1g-dev libbz2-dev 
    libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev curl wget git vim 


# R dependence software
apt install -y subversion ccache texlive texlive-fonts-extra texlive-latex-extra

# Oh my ZSH download 
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cp zshrc ~/.zshrc
