#!/bin/bash

chosen_editor="vim"
chosen_invoke=""
chosen_addkeys=0
help=0

while getopts sp:e:h opt; do
	case "$opt" in
		s)
			chosen_addkeys=1
			;;
		p)
			chosen_invoke="$OPTARG"
			;;
		e)
			chosen_editor="$OPTARG"
			;;
		\?|h)
			help=1
			;;
	esac
done

if [[ $help -ne 0 ]]; then
	cat <<HEREDOC
USage: $0 [-sh] [-p <invocation command>] [-e <editor>]

	-h: this help message.
	-s: whether to add SSH keys upon starting a shell. Default: false.
	-p: invoke a command at the end of .bashrc. try "fortune | cowsay" for some insight.
	-e: choose an editor and install a stock configuration file for it, if provided. Default: vim (of course).
HEREDOC
	exit 2
fi
[[ -f ~/.bashrc ]] && cp ~/.bashrc{,.old}

cd "$(dirname "$0")"
{
	if [[ "" != "$chosen_invoke" ]]; then echo "$chosen_invoke"; fi
	if [[ $chosen_addkeys -ne 0 ]]; then echo ssh-add; fi
	cat <<HEREDOC
PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
EDITOR="$chosen_editor"
HEREDOC
} > ~/.bashrc

if [[ "$chosen_editor" == "vim" ]]; then
	cp ./vimrc ~/.vimrc
fi
