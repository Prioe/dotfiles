function tmux-session-details --description 'List all tmux sessions with their windows'
    for session in (tmux list-sessions -F '#{session_name}')
        echo "=== $session ==="
        tmux list-windows -t $session -F '#{window_index}: #{window_name} - #{pane_current_command} in #{pane_current_path}'
    end
end
