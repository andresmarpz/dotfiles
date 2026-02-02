function theme --description "Toggle or set terminal theme (dark/light)"
    set -l dotfiles ~/dotfiles
    set -l kitty_conf $dotfiles/kitty/kitty.conf
    set -l tmux_conf $dotfiles/tmux/tmux.conf

    # Determine target theme
    if test (count $argv) -gt 0
        set target $argv[1]
    else
        # Toggle: detect current from the include line only
        if grep -q '^include themes/sandcastle-dark' $kitty_conf
            set target light
        else
            set target dark
        end
    end

    switch $target
        case dark
            sed -i '' 's|^include themes/sandcastle-light.conf|include themes/sandcastle-dark.conf|' $kitty_conf
            sed -i '' 's|sandcastle-light.conf$|sandcastle-dark.conf|' $tmux_conf
            echo "Switched to sandcastle-dark"
        case light
            sed -i '' 's|^include themes/sandcastle-dark.conf|include themes/sandcastle-light.conf|' $kitty_conf
            sed -i '' 's|sandcastle-dark.conf$|sandcastle-light.conf|' $tmux_conf
            echo "Switched to sandcastle-light"
        case '*'
            echo "Usage: theme [dark|light]"
            echo "  No argument toggles between dark and light"
            return 1
    end

    # Reload kitty via remote control (socket has PID suffix)
    for sock in /tmp/kitty-*
        kitty @ --to unix:$sock load-config 2>/dev/null
    end

    # Reload tmux config
    if set -q TMUX
        tmux source-file ~/.tmux.conf
        tmux display "Theme: $target"
    end
end
