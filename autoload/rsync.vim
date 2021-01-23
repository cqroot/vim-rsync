function! s:OnEvent(job_id, data, event) dict
    if a:event == 'stdout' || a:event == 'stderr'
        echom join(a:data)
    endif
endfunction

function! s:OnExit(job_id, data, event) dict
    if s:exit_cmd != ''
        execute '!echo "";'.s:exit_cmd
    endif
endfunction

function! rsync#job_start(cmd, exit_cmd) abort
    let s:exit_cmd = a:exit_cmd
    let job = jobstart(['bash', '-c', a:cmd], {
                \ 'on_stdout': function('s:OnEvent'),
                \ 'on_stderr': function('s:OnEvent'),
                \ 'on_exit': function('s:OnExit')
                \ })
endfunction
