# Disable fish greeting
set -U fish_greeting

# Environment variables
set -x EDITOR nvim
set -x VISUAL nvim
set -g fish_ssh_agent_identity ~/.ssh/id_rsa

# Aliases
alias lg="lazygit"
alias grep="rg"
alias clip="xclip -selection clipboard -i"

# opencode
fish_add_path /home/raicem/.opencode/bin

# Tool initializations
if test -x /usr/bin/mise
    /usr/bin/mise activate fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# Composer global bin directory
fish_add_path --append ~/.config/composer/vendor/bin
