# Vim Rsync

.vim-rsync

```
user: root
host: 127.0.0.1
target: /root/target_dir
exclude: {'node_modules/','*.pyc','.git/'}

```
Sync on save:

```vimscript
autocmd BufWritePost,FileWritePost * RsyncToRemote
```
