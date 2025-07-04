# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo history encode64 copypath zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='nvim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#neofetch
cdl() {
    cd "$@" && ls 
}

function chpwd() {
    pwd > ~/.last_dir
}

# alias
alias logind='sudo nvim /etc/systemd/logind.conf'
alias sound='pavucontrol'
alias cdl='cd $(<~/.last_dir)'
alias mstorage='sudo mount /dev/sda1 /media/b4haa7/Storage'
alias copy='xsel --input --clipboard'
alias paste='xsel --output --clipboard'
alias play='xdg-open /home/b4haa7/snap/yt-dlg/22/Downloads/i.xspf'
#alias rm='echo "This is not the command you are looking for."; false'
alias fdm=/opt/freedownloadmanager/fdm
alias nv='nvim'
alias cdm='cd /mnt/Storage/CS/'
alias uu='sudo pacman -Syu'
alias ta='task add'
alias tl='task list'
alias td='task done'
alias gg='git add . && git commit -m "alias" && git push'
alias ..='cd ..' 
alias ...='cd ../..' 
alias ....='cd ../../..' 
alias .....='cd ../../../..'
alias hotspoton='nmcli device wifi hotspot ifname wlp2s0 ssid مخمخ password 44444444'
alias hotspotoff='nmcli device disconnect wlan0'
alias fix-mouse='xinput set-prop 13 "libinput Tapping Enabled" 1'
#alias lf='lf-ueberzug'
alias r='ranger'
alias b='btop'
alias py='python3'
alias yt-download='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]"'
alias yt-audio='yt-dlp -x --audio-format mp3'
alias activate_global="source ~/my_global_venv/bin/activate"
#paths
export JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export PATH="$PATH:/home/b4haa7/.local/bin"
export EDITOR='nvim'
export PATH=$PATH:/home/ienjoycaffeine/apps/pycharm/bin
export PATH=$HOME/apps:$PATH
export PATH=$PATH:/home/ienjoycaffeine/scripts/
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"start

#neofetch | lolcat
# cowsay -f tux 'enjoy :)'
(
cat << 'EOF'




                                                                     ▄████▄   ▄▄▄        █████▒  █████▒▓█████  ██▓ ███▄    █ ▓█████  
                                                                    ▒██▀ ▀█  ▒████▄    ▓██   ▒ ▓██   ▒ ▓█   ▀ ▓██▒ ██ ▀█   █ ▓█   ▀ 
                                                                    ▒▓█    ▄ ▒██  ▀█▄  ▒████ ░ ▒████ ░ ▒███   ▒██▒▓██  ▀█ ██▒▒███  
                                                                    ▒▓▓▄ ▄██▒░██▄▄▄▄██ ░▓█▒  ░ ░▓█▒  ░ ▒▓█  ▄ ░██░▓██▒  ▐▌██▒▒▓█  ▄ 
                                                                    ▒ ▓███▀ ░ ▓█   ▓██▒░▒█░    ░▒█░    ░▒████▒░██░▒██░   ▓██░░▒████▒
                                                                    ░ ░▒ ▒  ░ ▒▒   ▓▒█░ ▒ ░     ▒ ░    ░░ ▒░ ░░▓  ░ ▒░   ▒ ▒ ░░ ▒░ ░
                                                                    ░  ▒     ▒   ▒▒ ░ ░       ░       ░ ░  ░ ▒ ░░ ░░   ░ ▒░ ░ ░  ░  
                                                                    ░          ░   ▒    ░ ░     ░ ░       ░    ▒ ░   ░   ░ ░    ░   
                                                                    ░ ░            ░  ░                   ░  ░ ░           ░    ░  ░                          



EOF
) 

#task list
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# autojump
[[ -s /usr/share/autojump/autojump.zsh ]] && source /usr/share/autojump/autojump.zsh
## [Completion]

## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/ienjoycaffeine/.dart-cli-completion/zsh-config.zsh ]] && . /home/ienjoycaffeine/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=24
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc

# Created by `pipx` on 2025-06-05 21:01:00
export PATH="$PATH:/home/ienjoycaffeine/.local/bin"
