function! LoadConfig()
    let l:config_file = findfile('.vim-rsync', '.;')

    let l:config_dict = {}
    let l:config_dict['src'] = fnamemodify(l:config_file, ':h')

    if strlen(l:config_file) > 0
        let l:f_config = readfile(l:config_file)

        for line in l:f_config
            if stridx(line, ':') > 0
                let l:config_item = split(line, ':')
                let l:item_name = substitute(l:config_item[0], '^\s*\(.\{-}\)\s*$', '\1', '')
                let l:item_value = substitute(l:config_item[1], '^\s*\(.\{-}\)\s*$', '\1', '')

                let l:config_dict[l:item_name] = l:item_value
            endif
        endfor
    endif

    return l:config_dict
endfunction

function! RsyncStart(...)
    let l:isToRemote = get(a:, 1, 1)
    let l:doRunCmd = get(a:, 2, 0)

    let l:config_dict = LoadConfig()

    if has_key(l:config_dict, 'host')
        let l:src = l:config_dict['src']
        let l:dst = l:config_dict['user'].'@'.l:config_dict['host'].':'.l:config_dict['target']

        let l:exclude_cmd = ''
        if has_key(l:config_dict, 'exclude')
            let l:exclude_cmd = '--exclude='.l:config_dict['exclude']
        endif

        let l:rsync_cmd_prefix = 'rsync -avzu --exclude .vim-rsync '.l:exclude_cmd

        if l:isToRemote == 1
            let l:rsync_cmd = l:rsync_cmd_prefix.' '.l:src.' '.l:dst
        else
            let l:rsync_cmd = l:rsync_cmd_prefix.' '.l:dst.' '.l:src
        endif

        let l:exit_cmd = ''
        if l:doRunCmd == 1
            if has_key(l:config_dict, 'cmd')
                let l:exit_cmd = 'ssh '.l:config_dict['user'].'@'.l:config_dict['host']." 'cd ".l:config_dict['target'].'; '.l:config_dict['cmd']."'"
            endif
        endif
        call rsync#job_start(l:rsync_cmd, l:exit_cmd)
    endif
endfunction

command! RsyncToRemote   call RsyncStart(1)
command! RsyncAndRun     call RsyncStart(1, 1)
command! RsyncFromRemote call RsyncStart(0)

if !executable('rsync')
    echoerr 'vim-rsync requires rsync'
    finish
endif

if exists("g:vim_rsync_sync_on_save")
    if g:vim_rsync_sync_on_save
        autocmd BufWritePost,FileWritePost * RsyncToRemote
    endif
endif
