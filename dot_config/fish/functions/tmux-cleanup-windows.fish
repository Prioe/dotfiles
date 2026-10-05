function tmux-cleanup-windows --description 'Kill all but the first window in inactive tmux sessions'
    set -l active_session (tmux list-sessions -F '#{session_name} #{session_attached}' | awk '$2 == "1" {print $1}')
    echo "Active session: $active_session (keeping all windows)"
    echo

    for session in (tmux list-sessions -F '#{session_name}' | grep -v "^$active_session\$")
        echo "=== Session: $session ==="
        for line in (tmux list-windows -t $session -F '#{window_index}: #{window_name}')
            set -l window_idx (echo $line | cut -d: -f1)
            if test "$window_idx" != 1
                echo "  [KILLING] Window $line"
                tmux kill-window -t "$session:$window_idx"
            else
                echo "  [KEEPING] Window $line"
            end
        end
        echo
    end

    echo "Cleanup complete!"
end
