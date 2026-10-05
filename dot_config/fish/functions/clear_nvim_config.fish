function clear_nvim_config --description 'Back up nvim cache/data/state dirs'
    set -l nvim_dirs \
        $XDG_CACHE_HOME/nvim \
        $XDG_DATA_HOME/nvim \
        $XDG_STATE_HOME/nvim

    set -l nvim_backup_dirs \
        $XDG_CACHE_HOME/nvim.bak \
        $XDG_DATA_HOME/nvim.bak \
        $XDG_STATE_HOME/nvim.bak

    for dir in $nvim_backup_dirs
        if test -d $dir
            echo "One or more backup directories already exist. Please remove them before running this script."
            echo "Run the following commands to remove the backup directories:"
            echo "rm -rf $nvim_backup_dirs"
            echo "Exiting..."
            return 1
        end
    end

    for dir in $nvim_dirs
        if test -d $dir
            echo "Backing up $dir to $dir.bak"
            mv $dir $dir.bak
        end
    end
end
