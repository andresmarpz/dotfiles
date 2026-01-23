function dev --description "Start a tmux dev session with lazygit, claude, and servers windows"
    # Get path (default to current directory)
    set -l project_path (realpath (test -n "$argv[1]" && echo $argv[1] || echo .))

    # Extract project name from path
    set -l session_name (basename $project_path)

    # Check if session already exists
    if tmux has-session -t $session_name 2>/dev/null
        echo "Session '$session_name' already exists. Switching..."
        if set -q TMUX
            tmux switch-client -t $session_name
        else
            tmux attach -t $session_name
        end
        return
    end

    # Create new session with first window (lazygit)
    tmux new-session -d -s $session_name -c $project_path -n lazygit

    # Window 1: lazygit (already in this window, just run it)
    tmux send-keys -t $session_name:lazygit "lazygit" Enter

    # Window 2: claude (single pane)
    tmux new-window -t $session_name -c $project_path -n claude
    tmux send-keys -t $session_name:claude "claude" Enter

    # Window 3: servers (2 vertical splits)
    tmux new-window -t $session_name -c $project_path -n servers
    tmux split-window -t $session_name:servers -h -c $project_path

    # Go back to window 2 (claude) by default
    tmux select-window -t $session_name:claude

    # Attach or switch to session
    if set -q TMUX
        # Already inside tmux, switch to new session
        tmux switch-client -t $session_name
    else
        # Outside tmux, attach normally
        tmux attach -t $session_name
    end
end
