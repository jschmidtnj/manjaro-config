#!/bin/bash

source /usr/share/nvm/init-nvm.sh

export PATH="$(yarn global bin):$PATH"
export PATH="$PATH:$HOME/go/bin"

# to get ros working using python 3.9
export PYTHONPATH="${PYTHONPATH}:/opt/ros/noetic/lib/python3.8/site-packages:/opt/ros/noetic/lib/python3.9/site-packages"

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# opam configuration
[[ ! -r /home/joshua/.opam/opam-init/init.zsh ]] || source /home/joshua/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
PATH="$PATH:$HOME/.opam/default/bin"

# chrome
PATH="$PATH:/opt/google/chrome"

# custom alias
alias open-pdf="okular"

