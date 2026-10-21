" ==================================================
" vimd（Markdown プレビュー）
" ==================================================
" HTML は CSS / JS ごと見たいので vimd ではなく既定のブラウザで開く
" （ブラウザに出るのは保存済みの内容）
function! s:preview() abort
  if &filetype ==# 'html'
    call v:lua.vim.ui.open(expand('%:p'))
  else
    VimdToggle
  endif
endfunction
nnoremap <silent> <leader>m :<C-u>call <SID>preview()<CR>
