
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


export PATH="$HOME/.cargo/bin:$PATH"

plugins=(git)
# fixes pos1, Ende and Entf keys
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

export EDITOR=nvim

source $ZSH/oh-my-zsh.sh

alias v="nvim"
alias h="cd ~/"
alias c="clear"
alias ls="ls --color=auto"
alias l="ls -la --color=auto"
alias n="kitty --detach"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}
