# this pushes my local obsidian vault to a remote git repo
function push_notes --description 'Commit and push the notes repo'
    # format: 12.02.2024, 16:06
    set -l T (date +'%d.%m.%Y, %H:%M')
    set -l H (hostnamectl hostname)
    git -C ~/notes add .
    git -C ~/notes commit -m "Pushing notes from $H at $T"
    git -C ~/notes push
end
