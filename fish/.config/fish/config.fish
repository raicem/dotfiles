# Disable fish greeting
set -U fish_greeting

# Start in last directory
if set -q __fish_last_dir
    cd $__fish_last_dir
end

function __fish_save_last_dir --on-variable PWD
    set -U __fish_last_dir $PWD
end

# Environment variables
set -x EDITOR nvim
set -x VISUAL nvim

# Aliases
alias lg="lazygit"
alias grep="rg"
alias clip="xclip -selection clipboard -i"

# opencode
fish_add_path $HOME/.opencode/bin

# Tool initializations
if test -x ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# Composer global bin directory
fish_add_path --append ~/.config/composer/vendor/bin

# npm global bin directory
fish_add_path --append ~/.npm-global/bin
