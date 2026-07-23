# Interactive zsh configuration.

# Keep PATH entries unique while preserving their first occurrence.
typeset -U path PATH
path=(
  /usr/local/bin
  /usr/local/sbin
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  $path
)

# Homebrew: use the fast bottle mirror for binary packages, but fetch the API
# and Git metadata from their official endpoints through the terminal proxy.
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_PIP_INDEX_URL="https://mirrors.aliyun.com/pypi/simple"
# Clear legacy overrides that may be inherited from a parent application.
unset HOMEBREW_API_DOMAIN HOMEBREW_BREW_GIT_REMOTE HOMEBREW_CORE_GIT_REMOTE

# Proxy helpers. Keep lowercase and uppercase variables aligned because command
# line tools differ in which spelling they recognize.
proxy_on() {
  local proxy_url="http://127.0.0.1:7890"
  local bypass="localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8"

  export http_proxy="$proxy_url" https_proxy="$proxy_url"
  export HTTP_PROXY="$proxy_url" HTTPS_PROXY="$proxy_url"
  export no_proxy="$bypass" NO_PROXY="$bypass"
  echo "终端代理已开启 (127.0.0.1:7890)"
}

proxy_off() {
  unset http_proxy https_proxy all_proxy
  unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
  unset no_proxy NO_PROXY
  echo "终端代理已关闭"
}

proxy_status() {
  if [[ -n ${https_proxy:-} ]]; then
    echo "终端代理：${https_proxy}"
  else
    echo "终端代理：未开启"
  fi
}

proxy_on

# Docker completion must be on fpath before Oh My Zsh initializes completion.
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git
  zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

# Conda initialization (managed structure, corrected to request a zsh hook).
if [[ -x "$HOME/opt/anaconda3/bin/conda" ]]; then
  __conda_setup="$("$HOME/opt/anaconda3/bin/conda" shell.zsh hook 2>/dev/null)"
  if [[ $? -eq 0 ]]; then
    eval "$__conda_setup"
  elif [[ -f "$HOME/opt/anaconda3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/opt/anaconda3/etc/profile.d/conda.sh"
  else
    path=("$HOME/opt/anaconda3/bin" $path)
  fi
  unset __conda_setup
fi

# Tool-specific environment files are optional.
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

alias hd='hexo clean && hexo g -d'
export EDITOR="zed --wait"
