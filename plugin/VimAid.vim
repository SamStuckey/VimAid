" MIT License
"
" Copyright (c) 2024 Samuel Stuckey
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

function! VimAidModal() abort
  " Use a default value for the close modal mapping if it's not defined
  let l:close_mapping = get(g:, 'vimaid_close_modal_mapping', '<C-a>')

  " Set dimensions for the modal
  let l:width = 100
  let l:height = 30

  " Calculate the position to center the modal
  let l:ui = nvim_list_uis()[0]
  let l:row = (l:ui.height - l:height) / 2
  let l:col = (l:ui.width - l:width) / 2

  " Set up session and file paths
  let l:current_dir = getcwd()
  let l:session_name = substitute(l:current_dir, '^/', '', '')
  let l:session_name = substitute(l:session_name, '/', '-', 'g')
  let l:filepath = expand('%:p')

  " Window options for modal
  let l:style_opts = {
        \ 'relative': 'editor',
        \ 'width': l:width,
        \ 'height': l:height,
        \ 'row': l:row,
        \ 'col': l:col,
        \ 'style': 'minimal',
        \ 'border': 'single'
        \ }

  " Create a buffer unless it already exists
  if !exists('g:vim_aid_buf') || !bufexists(g:vim_aid_buf)
    let g:vim_aid_buf = nvim_create_buf(v:false, v:true)

    let l:win = nvim_open_win(g:vim_aid_buf, v:true, l:style_opts)

    " Set up custom highlighting
    highlight CustomModalBackground guibg=#1c1c1c
    highlight FloatBorder guibg=NONE guifg=#D3D3D3
    call nvim_win_set_option(l:win, 'winhighlight', 'NormalFloat:CustomModalBackground,FloatBorder:FloatBorder')

    " Set terminal settings
    setlocal scrollback=10000 nonumber norelativenumber
    execute 'terminal'

    "" Headless set up of tmux and aider
    " Check if TMUX session is already running for filepath session
    let l:session_exists = system('tmux has-session -t ' . l:session_name)
    if v:shell_error != 0
      let l:start_session_cmd = 'tmux new-session -d -s ' . l:session_name
      call system(l:start_session_cmd)
      call system('tmux send-keys -t ' . l:session_name . " 'python3 -m aider' C-m")
    endif

    " Attach to TMUX session
    startinsert
    call feedkeys('tmux attach -t ' . l:session_name . "\n")
  else
    " Attach to existing buffer
    let l:win = nvim_open_win(g:vim_aid_buf, v:true, l:style_opts)
    startinsert
  endif

  " Add current file to Aider session and clear terminal clutter
  let l:add_file_cmd = 'tmux send-keys -t ' . l:session_name . " '/add " . l:filepath . "' C-m"
  call system(l:add_file_cmd)
  call system('tmux send-keys -t ' . l:session_name . " C-l")

  " Map close modal shortcut
  execute 'tnoremap <buffer>' l:close_mapping ' <C-\><C-n>:q<CR>'

  " Treat the aider / tmux session as immutable in the modal
  tnoremap <buffer> <C-c> <C-U><C-l>
  tnoremap <buffer> <C-d> <C-U><C-l>
endfunction

command! Aid call VimAidModal()
