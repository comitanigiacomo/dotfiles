# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=( 
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

ZSH_HIGHLIGHT_STYLES[default]='fg=white'

# 2. Comandi = BLU
ZSH_HIGHLIGHT_STYLES[command]='fg=14'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=14'
ZSH_HIGHLIGHT_STYLES[function]='fg=14'

# 3. Errori (es. path non trovato) = ROSSO SOTTOLINEATO
ZSH_HIGHLIGHT_STYLES[path_error]='fg=red,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,underline'

# 4. Argomenti giusti (path, stringhe) = VERDI (come erano prima)
ZSH_HIGHLIGHT_STYLES[path]='fg=green'
ZSH_HIGHLIGHT_STYLES[string]='fg=green'

# check the dnf plugins commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dnf


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

leet() {
    cd ~/personale/leetcode 

    FILE_PATH=$(python3 new_problem.py)

    if [[ "$FILE_PATH" == "problems/"* ]]; then
        
        DIR_PATH=$(dirname "$FILE_PATH")

        nohup kitty -e nvim "$FILE_PATH" > /dev/null 2>&1 &
        
        cd "$DIR_PATH"
        ls
        
    else
        echo "--- Errore dallo script Python ---"
        echo "$FILE_PATH"
        cd ~/personale/leetcode 
    fi

    clear
}
