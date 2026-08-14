function ssh --description 'Use Kitty SSH integration when available' --wraps ssh
    set --local kitty_ssh

    if test "$TERM" = xterm-kitty
        if command --search kitten >/dev/null
            set kitty_ssh kitten ssh
        else if command --search kitty >/dev/null
            set kitty_ssh kitty +kitten ssh
        else if test -x /Applications/kitty.app/Contents/MacOS/kitten
            set kitty_ssh /Applications/kitty.app/Contents/MacOS/kitten ssh
        end
    end

    if set --query kitty_ssh[1]
        command $kitty_ssh $argv
    else
        command ssh $argv
    end
end
