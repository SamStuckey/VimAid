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


function! VimAidModal()
  if !exists('g:vimaid_close_modal_mapping')
    let g:vimaid_close_modal_mapping = '<C-a>'
  endif
  let width = 80 " Set width of the modal
  let height = 24 " Set height of the modal
  let row = (winheight(0) - height) / 2
  let col = (winwidth(0) - width) / 2
  let l:current_dir = getcwd()
  let l:session_name = substitute(l:current_dir, '^/', '', '')  " Remove leading slash if any
  let l:session_name = substitute(l:session_name, '/', '-', 'g') " Replace slashes with dashesid
  let l:filepath = expand('%:p')

  " Create a buffer buffer unless it already exists
  if !exists('g:buf') || !bufexists(g:buf)
    echo "creating buffer"
    " create buffer in new modal
    " echo 'creating buffer'
    let g:buf = nvim_create_buf(0, 1)
    let win = nvim_open_win(g:buf, 1, {
          \ 'relative': 'editor',
          \ 'width': width,
          \ 'height': height,
          \ 'row': row,
          \ 'col': col,
          \ 'style': 'minimal',
          \ })
    execute 'terminal'
    setlocal nonumber norelativenumber

    "" Headless set up of tmux and aider 
    " Check if TMUX session is already running for filepath session
    let l:session_exists = system('tmux has-session -t ' . l:session_name)
    " Create TMUX session if it's not already running
    if v:shell_error != 0
        echo "Starting Tmux session: " . l:session_name
        let l:start_session_cmd = "tmux new-session -d -s " . l:session_name
        call system(l:start_session_cmd)
        " Start Aider chat in TMUX session
        call system("tmux send-keys -t " . l:session_name . " 'python3 -m aider' C-m")
    endif

    " Connect to TMUX in terminal buffer 
    startinsert
    call feedkeys("tmux attach -t " . l:session_name . "\n")
  else
    " attach to the existing buffer
    echo 'connecting to buffer'
    let win = nvim_open_win(g:buf, 1, {
          \ 'relative': 'editor',
          \ 'width': width,
          \ 'height': height,
          \ 'row': row,
          \ 'col': col,
          \ 'style': 'minimal',
          \ })
    startinsert
  endif

  " Add current file to aider session
  let l:prompt_cmd = "tmux send-keys -t " . l:session_name . " '/add " . l:filepath . "' C-m"
  call system(l:prompt_cmd)
  " clear the spew from file load
  sleep 100m
  call system("tmux send-keys -t " . l:session_name . "C-c C-l")

  " map close shortcut to buffer
  execute 'tnoremap <buffer>' g:vimaid_close_modal_mapping ' <C-\><C-n>:q<CR>'
endfunction
command! Aid call VimAidModal()
