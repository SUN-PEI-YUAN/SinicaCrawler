sudo apt update && sudo apt upgrade -y
# basic install
sudo apt install -y sudo htop git gcc cpp vim tor polipo wget curl dos2unix tesseract-ocr libtesseract-dev


sudo apt update; sudo apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev


git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="/home/crawler/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

source .bashrc

pyenv install 3.7.4
pyenv global 3.7.4
pip install --upgrade pip 
pip install virtualenv
#git

cp torrc /etc/tor/torrc
cp polipo.conf /etc/polipo/config