# Vim Rsync

## Usage

Create a .vim-rsync file in the project root directory that contains the following:

```ini
user    : root
host    : 127.0.0.1
target  : /root/target_dir
exclude : {'node_modules/','*.pyc','.git/'}
cmd     : python demo.py
```

Among them, user, host, target parameters are required.

## Command

- RsyncToRemote: Sync local files to remote.
- RsyncFromRemote: Sync remote files to local.
- RsyncAndRun: Run command after syncing to remote.

## configuration

Sync on save:

```vimscript
let g:vim_rsync_sync_on_save = 1
```
