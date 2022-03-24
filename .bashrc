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
export OKD_RELEASE=4.7.0-0.okd-2021-03-07-090821
