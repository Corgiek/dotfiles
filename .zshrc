ZHOME=$HOME/.local/zsh

HISTFILE=$ZHOME/histfile
HISTSIZE=10000
SAVEHIST=10000
ZSH_LOAD_SYSTEM_PLUGINS=yes
setopt autocd extendedglob nomatch notify pipefail beep CORRECT_ALL
zstyle :compinstall filename '${HOME}/.zshrc'

# Zle arrow-movement
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey -v
autoload -Uz compinit promptinit colors
compinit
promptinit
colors

## Prompt stuff
# Helper functions for prompt
# determine cursor position to either start with/out newline
cup(){
  echo -ne "\033[6n" > /dev/tty
  read -t 1 -s -d 'R' line < /dev/tty
  line="${line##*\[}"
  line="${line%;*}"
  echo "$line"
}

#Collapse path to single chars if it gets too long
collapse_pwd() {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

#Truncate the dir path
truncated_pwd() {
  n=$1 # n = number of directories to show in full (n = 3, /a/b/c/dee/ee/eff)
  path=`collapse_pwd`

  # split our path on /
  dirs=("${(s:/:)path}")
  dirs_length=$#dirs

  if [[ $dirs_length -ge $n ]]; then
    # we have more dirs than we want to show in full, so compact those down
    ((max=dirs_length - n))
    for (( i = 1; i <= $max; i++ )); do
      step="$dirs[$i]"
      if [[ -z $step ]]; then
        continue
      fi
      if [[ $step =~ "^\." ]]; then
        dirs[$i]=$step[0,2] #make .mydir => .m
      else
        dirs[$i]=$step[0,1] # make mydir => m
      fi

    done
  fi

  echo ${(j:/:)dirs}
}

#Vim mode helper function; notifies current state
zle-keymap-select() {
    if [[ $KEYMAP == vicmd ]]; then
        vim_mode=${vim_cmd_mode}
    elif [[ $KEYMAP == (main|viins) ]] && [[ $ZLE_STATE == *insert* ]]; then
        vim_mode=${vim_ins_mode}
    elif [[ $KEYMAP == (main|viins) ]] && [[ $ZLE_STATE == *overwrite* ]]; then
        vim_mode=${vim_rep_mode}
    else
        vim_mode="?"
    fi
    custom_prompt
    zle reset-prompt
}
zle -N zle-keymap-select

zle-line-finish() {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

# Preexec function
setup() {
    # Change window title to current command right after command is inputted
    print -Pn "\e]0;$1\a"
}

# Classy touch inspired prompt
custom_prompt() {
    cmd_cde=$?
    # Set window title
    print -Pn "\e]2;%n@%M: %~\a"
  cpos=$(cup)
  case "$cpos" in
    1|2)
          PROMPT=""
      ;;
    *)
          PROMPT=$'\n'
      ;;
  esac
    PROMPT+="%{$fg[red]%}┏━"

    #Are we root?
    [ "$(id -u)" -eq 0 ] && PROMPT+="[%{$fg[white]%}root%{$fg[red]%}]%{%G━%}"

    #Current directory
    PROMPT+="[%{$fg[white]%}%{$(truncated_pwd 3)%}%{$fg[red]%}]"

    # Background job indicator
    PROMPT+="%(1j.━[%{$reset_color%}⚙%F{1}]%f.)"

    if [ $cmd_cde -eq 0 ]; then
        PROMPT+=$'\n'"%{$fg[red]%}┗━━ %F{8}${vim_mode}%f %{$reset_color%}"
    else
        PROMPT+=$'\n'"%{$fg[red]%}┗━━ %{$reset_color%}${vim_mode} "
    fi

    setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec setup
add-zsh-hook precmd custom_prompt
export PROMPT2="%F{1}━━━━━%f%F{8} %{%G■%}%f%{$reset_color%} "

# Default to vi mode bay-bee
bindkey -v
bindkey -v '^?' backward-delete-char
vim_ins_mode="■"
vim_cmd_mode="□"
vim_rep_mode='☒'
vim_mode=$vim_ins_mode

function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}

# Source plugins
source $ZHOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZHOME/zsh-autosuggestions/zsh-autosuggestions.zsh

# Setup fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Completion
autoload -Uz compinit; compinit
setopt complete_in_word
unsetopt completealiases
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZHOME/zcompcache"
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' separate-sections true
zstyle ':completion:*' insert-sections true
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:options' list-colors '=^(-- *)=35'
zstyle ':completion:*:descriptions' format '%F{8}■%f %F{red}━━━[%f%d%F{red}]%f'
zstyle ':completion:*:messages' format '%F{8}■%f %F{red}━━━[%f%d%F{red}]%f'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Aliases
alias ls='exa -lahF --color=always --icons'
alias ip='ip --color=auto'
alias newsboat='newsboat -q'
alias diff='diff --color=auto'
alias cat='bat'
alias grep='rg'
alias qemus='qemu-system-x86_64 -enable-kvm -machine q35 -device virtio-vga-gl -cpu host -display gtk,gl=es -m 4096 -smp 8'
alias cp="cp --reflink"
alias weather="curl wttr.in"
alias termbin="nc termbin.com 9999"

### Functions
# Colorized man pages
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;40;35m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;33m") \
        man "$@"
}

# auto cd on exiting lf with 'Q'
lf () {
    local tempfile="$(mktemp)"
    command lf -command "map Q \$echo \$PWD >$tempfile; lf -remote \"send \$id quit\"" "$@"

    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n $(pwd))" ]]; then
          cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}
