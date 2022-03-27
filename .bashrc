# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


export PATH="$HOME/bin:$PATH"
. /root/bin/setSncEnv.sh
export OKD_RELEASE=4.9.0-0.okd-2022-02-12-140851
# export OKD_RELEASE=4.10.0-0.okd-2022-03-07-131213
