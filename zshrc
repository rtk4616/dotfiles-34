#!/usr/bin/zsh

TERM="xterm-256color"
HISTFILE="${HOME}/.zshhistory"
SAVEHIST=5000
HISTSIZE=5000
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
#load zplug
source /usr/local/opt/zplug/init.zsh
fpath=(/usr/local/share/zsh-completions $fpath)
ttyctl -f #fixes error where the terminal confuses enter with return (prints ^M)
export $EDITOR=atom
export $BROWSER=google-chrome
export HOMEBREW_NO_AUTO_UPDATE=1
#less syntax-highlighting
export LESS="--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4"
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
export LESSCOLORIZER='pygmentize'

#npm settings
# this is the root folder where all globally installed node packages will  go
export NPM_PACKAGES="/usr/local/npm_packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
# add to PATH
export PATH="$NPM_PACKAGES/bin:$PATH"

#mdv theme
export MDV_THEME="734.0784, 20"

# Bundles from the default repo (robbyrussell's oh-my-zsh).
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/autojump", from:oh-my-zsh #needs to be installed via homebrew
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/brew-cask", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/yarn", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh

# zplug djui/alias-tips
zplug "zsh-users/zsh-completions", depth:1 #more completions
zplug "zsh-users/zsh-autosuggestions", from:github #proposes transparent suggestions based on command history
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:1
zplug "zsh-users/zsh-history-substring-search", from:github, defer:3
zplug "lukechilds/zsh-better-npm-completion", defer:2
zplug "wbinglee/zsh-wakatime", from:github
zplug "ascii-soup/zsh-url-highlighter", from:github
zplug "zdharma/fast-syntax-highlighting", from:github
zplug "zdharma/zui", from:github
zplug "zdharma/zbrowse", from:github
zplug "supercrabtree/k", from:github #better ls
zplug "akoenig/gulp", from:github

if zplug check zsh-users/zsh-autosuggestions; then
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
fi

if zplug check zsh-users/zsh-history-substring-search; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_FUZZY=true
fi

#theme stuff
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir virtualenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_TIME_FORMAT="%D{ %H:%M:%S}"
POWERLEVEL9K_STATUS_VERBOSE=false #only show status if failed
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_VCS_GIT_ICON=
# POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=
# POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=black,bold' #define colors for found items

POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="\u2570\uf460 "
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme


export DEFAULT_USER="mitochondrium" #hide user in prompt if default user
export HOMEBREW_CASK_OPTS="--appdir=/Applications" #give correct location to homebrew cask
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

#aliases
alias yad="yarn add --dev"
alias -g latest='*(om[1])'

#show dots for slow autocompletion
expand-or-complete-with-dots() {
  echo -n "\e[31m...\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# Automatically list directory contents on `cd`.
auto-ls () { colorls -A --sd; }
chpwd_functions=( auto-ls $chpwd_functions )

# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
  source `brew --prefix`/etc/grc.bashrc
fi


#fixes for autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

#colorize ls output
alias ls='colorls -A --sd'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
