# Set up the prompt

autoload -Uz promptinit
promptinit
prompt walters

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
EDITOR=vim

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

source ~/.zprompt

precmd

## Global Aliases
alias -g L="| less"
alias -g G="| grep"
alias -g C="| wc -l"
alias -g T="| tail"
alias -g H="| head"
alias -g DN="/dev/null"
alias -g ENC="| openssl enc -aes256"
alias -g DEC="| openssl enc -aes256 -d"
alias -g RT="> /tmp/zsh_temp"

## Normal Aliases
alias ls="ls --color=yes"
alias l="ls -F"
alias ll="ls -alF"
alias lsd='ls -al | grep "^d"' 
alias grep="egrep --color=auto"
alias ..="cd .."
alias http="w3m"
alias vi="vim -p"
alias excuse='telnet towel.blinkenlights.nl 666'

## Functions
extract() {
  if [[ -z "$1" ]]; then
    print -P "usage: \e[1;36mextract\e[1;0m < filename >"
    print -P "       Extract the file specified based on the extension"
  elif [[ -f $1 ]]; then
    case ${(L)1} in
      *.tar.bz2)  tar -jxvf $1	;;
      *.tar.gz)   tar -zxvf $1	;;
      *.tar.xz)   tar -Jxvf $1  ;;
      *.bz2)      bunzip2 $1	   ;;
      *.gz)       gunzip $1	   ;;
      *.jar)      unzip $1       ;;
      *.rar)      unrar x $1	   ;;
      *.tar)      tar -xvf $1	   ;;
      *.tbz2)     tar -jxvf $1	;;
      *.tgz)      tar -zxvf $1	;;
      *.txz)      tar -Jxvf $1  ;;
      *.zip)      unzip $1	      ;;
      *.Z)        uncompress $1	;;
      *)          echo "Unable to extract '$1' :: Unknown extension"
    esac
  else
    echo "File ('$1') does not exist!"
  fi
}

wiki() {
  if [ ! -z ${1} ]; then
    dig +short txt $*.wp.dg.cx
  else
    echo "Usage: ${0} \"<search string>\""
  fi
}

## Git functions
ga() {
  if [ -z ${1} ]; then
    echo "[-] Usage: ${0} <files to add>"
  else
    git add "${@}"
  fi
}

gc() {
  if [ -z ${1} ]; then
    echo "[-] Usage: ${0} <Commit blam>"
  else
    git commit -m "${@}"
  fi
}

gp() {
  git push -u origin master
}

pwgen() {
    if [ -z ${1} ]; then
        openssl rand -base64 9
    else
        for ((i=1; i<=${1}; i++)); do
            openssl rand -base64 9
        done | column
    fi
}

httptest() {
    if [ ${#} -ne 2 ]; then
        echo "Usage: httptest {host} {fqdn}"
    else
        (echo "GET / HTTP/1.1\nHOST: ${2}\n\n"; sleep 2) | telnet ${1} 80
    fi
}
