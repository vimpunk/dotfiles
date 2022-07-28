# TODO: what does this do? this was here by default
[[ $- != *i* ]] && return

# ==============================================================================
# Path
# ==============================================================================

export EDITOR='lvim'
export GOPATH=$HOME/go

# own scripts
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin
# rust
export PATH=$PATH:$HOME/.cargo/bin
# ruby
export PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
# snap
export PATH=$PATH:/var/lib/snapd/snap/bin/
# go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
# npm/yarn
export PATH=$PATH:$HOME/.npm-global/bin
export PATH=$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin

if [[ "$OSTYPE" == darwin* ]]
then
  # FIXME: workaround for nvim-lsp not finding RA
  export PATH=$PATH:$HOME/.local/share/nvim/lsp_servers/rust_analyzer
  # homebrew installed python
  export PATH=$PATH:/usr/local/share/python
  export PATH=$PATH:/usr/local/opt/python/libexec/bin
  export PATH=$PATH:/opt/homebrew/opt/llvm/bin
  export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/lib
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/homebrew/opt/cyrus-sasl/lib/pkgconfig
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/homebrew/opt/openssl@3/lib/pkgconfig
  export OPENSSL_ROOT_DIR="/opt/homebrew/opt/openssl@3"

fi

# ==============================================================================
# Settings
# ==============================================================================

export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

setopt AUTO_CD # No cd needed to change directories
setopt BANG_HIST # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY # Share history between all sessions.

# ==============================================================================
# Aliases
# ==============================================================================

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'
alias l='ls -l'
# show dotfiles
alias l.="ls -A | egrep '^\.'"

# Vim ruined me...
alias :q='exit'
# ignore welcome banner
alias gdb='gdb -q'
alias ytmp3='youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 '
alias repl=evcxr
alias clippy="cargo clippy --all --all-targets --all-features -- -D rust-2018-idioms"
if which lvim &> /dev/null
then
  alias nvim=lvim
fi


if [[ "$OSTYPE" == linux* ]]
then
  alias performance="echo performance | sudo tee /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor"
  alias powersave="echo powersave | sudo tee /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor"
fi

alias k=kubectl
alias aws='docker run --rm -it -v ~/.aws:/root --network host amazon/aws-cli'

# ==============================================================================
# Vim mode
# ==============================================================================

# use vim keybindings
# NOTE: has to be before fzf
bindkey -v
# use jk to escape inert mode
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^w' backward-kill-word
bindkey -M viins '^U' backward-kill-line
# cycle through history as in emacs mode
bindkey '^P' up-history
bindkey '^N' down-history

# ==============================================================================
# Plugins
# ==============================================================================

# Compiles a zsh plugin script into zsh byte code for faster startup times.
function source-compiled {
    plugin_path=$1
    compiled_path=$1.zwc
    # If there is no *.zsh.zwc or it's older than *.zsh, compile *.zsh into *.zsh.zwc.
    if [[ ! "${compiled_path}" -nt "${plugin_path}" ]]; then
      zcompile "${plugin_path}"
    fi
    source "${plugin_path}"
}

my_zsh_plugins_dir=~/dotfiles/zsh-plugins/

# NOTE: has to be before all uses of `zsh-defer`
source "${my_zsh_plugins_dir}/zsh-defer/zsh-defer.plugin.zsh"

zsh-defer source-compiled "${my_zsh_plugins_dir}/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^F' autosuggest-execute
bindkey '^A' autosuggest-accept

zsh-defer source-compiled "${my_zsh_plugins_dir}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# ask cargo to use the system wide git binary so that we use the system credentials store
CARGO_NET_GIT_FETCH_WITH_CLI=true

# ==============================================================================
# Tools
# ==============================================================================

# Ask cargo to use the git binary instead of the lib for authentication. This
# allows reusing the configured git credential store.
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# fzf
# NOTE: has to be after setting vim mode
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ==============================================================================
# Prompt
# ==============================================================================

eval "$(starship init zsh)"
