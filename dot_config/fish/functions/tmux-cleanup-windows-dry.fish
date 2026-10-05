function tmux-cleanup-windows-dry --description 'Show which tmux windows a cleanup would kill'
    set -l active_session (tmux list-sessions -F '#{session_name} #{session_attached}' | awk '$2 == "1" {print $1}')
    echo "Active session: $active_session"
    echo

    for session in (tmux list-sessions -F '#{session_name}' | grep -v "^$active_session\$")
        echo "=== Session: $session ==="
        for line in (tmux list-windows -t $session -F '#{window_index}: #{window_name}')
            set -l window_idx (echo $line | cut -d: -f1)
            if test "$window_idx" != 1
                echo "  [WOULD KILL] Window $line"
            else
                echo "  [KEEP] Window $line"
            end
        end
        echo
    end
end
