function prepare_edit_claude_code_src --description 'cd to claude-code src and prettify cli.js'
    cd (dirname (readlink -f (which claude)))
    mise x npm:prettier@latest -- prettier cli.js --write --log-level debug
end
