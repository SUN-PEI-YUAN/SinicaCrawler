git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="/home/crawler/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

source ~/.bashrc

pyenv install 3.7.4
pyenv global 3.7.4
pip install --upgrade pip 
pip install virtualenv

cp torrc /etc/tor/torrc
cp polipo.conf /etc/polipo/config