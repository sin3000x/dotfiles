# Login-shell environment. Keep PATH entries unique.
typeset -U path PATH

# Homebrew on Intel macOS.
if [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Optional system toolchains retained from their installers.
path=(
  /opt/local/bin
  /opt/local/sbin
  /usr/local/opt/python@3.13/bin
  /usr/local/opt/python@3.13/libexec/bin
  $path
)

export HOMEBREW_PIP_INDEX_URL="https://mirrors.aliyun.com/pypi/simple"
