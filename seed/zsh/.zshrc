# --- vimable: 補完 ---
fpath+=(/opt/homebrew/share/zsh/site-functions)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# --- vimable: Pure テーマ ---
autoload -U promptinit; promptinit
prompt pure

# --- vimable: rbenv ---
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

# --- vimable: nvim ---
alias vi="nvim"
alias vim="nvim"

# --- vimable: tmux ---
tmax() {
  if [ $# -eq 0 ]; then
    tmux attach -t main 2>/dev/null || tmux new -s main
  else
    tmux "$@"
  fi
}
