" ==================================================
" fzf（ファジーファインダー）
" ==================================================
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>

" --- Files: 右 split で開く ---
function! s:open_file_in_right_vsplit(lines) abort
  for l:file in a:lines
    if empty(l:file) | continue | endif
    execute 'rightbelow vsplit' fnameescape(l:file)
  endfor
endfunction

command! -nargs=* FilesRight call fzf#vim#files(
  \ <q-args>,
  \ fzf#vim#with_preview({'sink*': function('s:open_file_in_right_vsplit')}),
  \ 0)

nnoremap <leader>ff :FilesRight<CR>

" --- Rg: 右 split + 行ジャンプ ---
function! s:open_in_right_vsplit(lines) abort
  if len(a:lines) < 2 | return | endif
  let l:parts = split(a:lines[1], ':', 1)
  if len(l:parts) < 3 | return | endif

  execute 'rightbelow vsplit' fnameescape(l:parts[0])
  call cursor(str2nr(l:parts[1]), str2nr(l:parts[2]))
  normal! zvzz
endfunction

command! -nargs=* Rg call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --hidden --smart-case --glob "!.git/*" '
  \ . shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview({'sink*': function('s:open_in_right_vsplit')}),
  \ 0)

nnoremap <leader>fg :Rg<CR>
