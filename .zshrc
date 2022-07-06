ZHOME=$HOME/.local/zsh

HISTFILE=$ZHOME/histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify pipefail beep CORRECT_ALL
bindkey -v
zstyle :compinstall filename '${HOME}/.zshrc'

# Zle arrow-movement
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

autoload -Uz compinit promptinit colors
compinit
promptinit
colors

PROMPT="
%{$fg[red]%} »  %{$reset_color%}"
RPROMPT="%B%{$fg[white]%}%~%{$reset_color%}"

source $ZHOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZHOME/zsh-autosuggestions/zsh-autosuggestions.zsh 

alias ls='ls -lahF --color=auto'
alias record='wf-recorder -a -c h264_vaapi -d /dev/dri/renderD128 -e -f'
alias qemus='qemu-system-x86_64 -enable-kvm -machine q35 -device intel-iommu -device virtio-vga-gl -cpu host -display gtk,gl=on -m 8192 -smp 8'
alias neofetch='./.local/bin/neofetch'

ZSH_LOAD_SYSTEM_PLUGINS=yes
