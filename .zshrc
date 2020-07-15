# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="bureau-filedesless"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-completions
)


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

work_config() {
  source $ZSH/oh-my-zsh.sh
  source /etc/bash_completion.d/g4d
  source /etc/bash_completion.d/p4

  #source /etc/bash_completion.d/blaze
  # https://g3doc.corp.google.com/devtools/blaze/scripts/zsh_completion/README.md?cl=head
  # fpath=(/google/src/files/head/depot/google3/devtools/blaze/scripts/zsh_completion $fpath)
  [ -d "$HOME/src/zsh_completion" ] && fpath=($HOME/src/zsh_completion $fpath)
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path ~/.zsh/cache
  _blaze_query_tmux() {
    tmux display-message 'Querying blaze'
    $@
  }
  zstyle ':completion:*:blaze-*:query' command -_blaze_query_tmux

  alias python3_depcheck=/google/data/ro/teams/python-team/python3_depcheck
  alias python3_convert=/google/bin/releases/python-team/public/python3_convert
  alias tmux=tmx2

  setopt prompt_subst  # enable command substitution (and other expansions) in PROMPT
  PROMPT='%F{cyan}%n%f α %F{green}%m%f φ $(google3_prompt_info)%f'$'\n'' λ '  # %f for stopping the foreground color

  [ -d "$HOME/src/depot_tools" ] && export PATH=$PATH:$HOME/src/depot_tools

}

[[ "$(hostname)" =~ "corpbox" ]] && work_config || ZSH_THEME="bureau-filedesless" source $ZSH/oh-my-zsh.sh

alias vi="vim"
export EDITOR=vim

if [ $(uname -s) = "Darwin" ]; then
  export PATH=/usr/local/Cellar/openvpn/2.4.6/sbin:$PATH
  export MAKEFLAGS="$MAKEFLAGS -j$(sysctl -n hw.ncpu)"
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
  export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --exclude Library --exclude node_modules'
  export FZF_ALT_C_COMMAND='fd --type d --exclude .git --exclude Library --exclude node_modules'
  export FZF_CTRL_T_COMMAND='fd --type f --exclude .git --exclude Library --exclude node_modules'
fi

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
fi

if [ -n "${commands[fzf]}" ]; then
  alias ef="fzf --preview 'bat --color \"always\" {}' --bind='enter:execute($EDITOR {})+abort'"
fi

[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin/:"$PATH

bindkey '^ ' autosuggest-accept
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [ -n "${commands[direnv]}" ]; then
   eval "$(direnv hook zsh)"
fi

[ -f "/usr/share/fzf/key-bindings.zsh" ] && source /usr/share/fzf/key-bindings.zsh
[ -f "/usr/share/fzf/completion.zsh" ] && source /usr/share/fzf/completion.zsh

google3_prompt_info() {
  if [[ $PWD =~ '/google/src/cloud/[^/]+/(.+)/google3(.*)' ]]; then
    # Use CitC client names as window titles in screen/tmux
    #print -n "\ek${match[1]}\e\\"
    print -r -- "%F{magenta}($match[1]) %F{yellow}//${match[2]#/}"
  else
    print -r -- "%F{yellow}%~"
  fi
}

[ -f /usr/share/doc/fzf/examples/key-bindings.zshsource ] && /usr/share/doc/fzf/examples/key-bindings.zsh

which opam > /dev/null && eval $(opam env)
