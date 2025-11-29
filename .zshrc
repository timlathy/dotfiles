###
### Aliases
###

alias vim="vimx" # vim with clipboard support
alias yt="mpsyt"
alias jup="stack --resolver lts-14.17 exec jupyter -- notebook"
alias httpserver8000="python3 -m http.server 8000"
alias history="history 1" # display all entries when running `history`
alias gdiff="colordiff -u" # git-style diff

# Example usage: texwatch report.tex
function texwatch {
  while ! inotifywait -e close_write $1; do
    xelatex $1
  done
}

function texwatchpy {
  while ! inotifywait -e close_write $1; do
    xelatex $1
    pythontex --interpreter python:python3 $1
    xelatex $1
  done
}

function texwatchbib {
  while ! inotifywait -e close_write $1; do
    xelatex $1; biber "${1%.*}"; xelatex $1
  done
}

# Example usage: watchcmd plantuml diagram.plantuml
# (texwatch can be rewritten as watchcmd xelatex)
function watchcmd {
  while ! inotifywait -e close_write "${@: -1}"; do
    $@
  done
}

# gsub path regex
# Example usage: gsub css/ "s/--body-font/--main-font/g"
# (replaces occurrences of --body-font in all files in css/)
function gsub {
  find "$1" -type f -print0 | xargs -0 -n 1 sed -i -e "$2"
}

# mergepdf destination.pdf source.pdf...
function mergepdf {
  /bin/gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

# Example usage: prettyjson response.json > responsepretty.json
function prettyjson {
  python -m json.tool -
}

# Example usage: whisper audio.mp3
function whisper {
  local filepath="$1"
  local dir="${filepath%/*}"
  local filename="${filepath##*/}"
  [[ "$dir" == "$filepath" ]] && dir="$PWD"
  docker run -it --rm -v "$dir:/src:z" -w /src --network=none whisper /whisper/bin/whisper --model_dir=/whisper "$filename" "${@:2}"
}

alias ga="git add"
alias gs="git status"
alias gr="git reset"
alias gd="git diff"
alias gds="git diff --staged"
alias gc="git commit"
alias gp="git push"
alias gl="git log"

setopt auto_pushd # pushd behavior with cd
setopt pushd_ignore_dups
setopt pushd_silent

###
### Bindings
###

TERM=xterm-256color

bindkey -v
export KEYTIMEOUT=1 # remove the delay after hitting <ESC> (Vi mode)

bindkey "^?" backward-delete-char
bindkey -M vicmd '^[[3~' delete-char
bindkey -M viins '^[[3~' delete-char

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[5~" beginning-of-line
bindkey "^[[6~" end-of-line

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

###
### History
###

HISTFILE=~/.histfile
HISTSIZE=200000
SAVEHIST=200000
HISTORY_IGNORE="ls:pwd:exit:history*"

setopt share_history      # share history between sessions
setopt inc_append_history # don't wait for the shell to exit before writing to HISTFILE
setopt hist_save_no_dups  # don't save duplicate entries

###
### Completion
###

autoload -Uz compinit && compinit

setopt extended_glob

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' file-sort modification

fpath=(~/.zsh/zsh-completions/src $fpath)

# Disable remote path globbing for scp
# https://unix.stackexchange.com/a/106981
alias scp='noglob scp_wrap'
function scp_wrap {
  local -a args
  local i
  for i in "$@"; do case $i in
    (*:*) args+=($i) ;;
    (*) args+=(${~i}) ;;
  esac; done
  command scp "${(@)args}"
}

###
### Prompt
###

autoload -U colors && colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[blue]%} %b %m"
zstyle ':vcs_info:git*' actionformats "%{$fg[blue]%} %b: %a %m"

# https://github.com/johan/zsh/blob/master/Misc/vcs_info-examples
zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "▲ ${ahead}" )

    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "▼ ${behind}" )

    hook_com[misc]+=${(j: :)gitstatus}
}

precmd() { vcs_info }

function zle-line-init zle-keymap-select {
  vi_mode_color="${${KEYMAP/vicmd/green}/(main|viins)/magenta}"
  mode_arrow="%{$fg[${vi_mode_color}]%}⤷ %{$reset_color%}"

  user="%{$fg[magenta]%}%n"
  cwd="%{$fg[cyan]%}(%~)"
  retcode="%(?..%{$fg[red]%}[%?] )"

  PS1="${user} ${cwd}${vcs_info_msg_0_}${retcode}"$'\n'${mode_arrow}

  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

###
### Environment
###

# source $HOME/.asdf/asdf.sh
# source $HOME/.asdf/completions/asdf.bash
PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin

###
### Plugins
###

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
