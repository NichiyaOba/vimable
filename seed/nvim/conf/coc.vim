" ==================================================
" Coc / LSP
" ==================================================
" 自動インストールするcoc拡張機能
let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-go',
      \ 'coc-json',
      \ ]

function! s:coc_jump_vsplit(action) abort
  " 元ウィンドウを記録
  let l:origin_win = win_getid()

  " 右に split
  rightbelow vsplit

  " 新しいウィンドウでジャンプ
  call CocAction(a:action)

  " ジャンプ失敗したら元に戻す
  if win_getid() == l:origin_win
    echo "No definition found"
    return
  endif

  normal! zvzz
endfunction

nnoremap <silent> gd :call <SID>coc_jump_vsplit('jumpDefinition')<CR>
nnoremap <silent> gy :call <SID>coc_jump_vsplit('jumpTypeDefinition')<CR>
nnoremap <silent> gi :call <SID>coc_jump_vsplit('jumpImplementation')<CR>
" references は複数候補があるためcoc-listを使用
nmap <silent> gr <Plug>(coc-references)


inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" カーソル下のシンボルと同じシンボルをハイライト（VSCode風）
autocmd CursorHold * silent call CocActionAsync('highlight')

" ハイライトの色設定
highlight CocHighlightText guibg=#3d4f5f gui=bold
highlight CocHighlightRead guibg=#304030 gui=bold
highlight CocHighlightWrite guibg=#503030 gui=bold

" 定義ジャンプの戻り
nnoremap <leader>b <C-o>   " 戻る
nnoremap <leader>f <C-i>   " 進む

" ==================================================
" 保存時フック（言語別）
" ==================================================
" JS / TS
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx
      \ :silent! call CocAction('runCommand', 'editor.action.organizeImport')

" Go
autocmd BufWritePre *.go :silent! call CocAction('organizeImport')
autocmd BufWritePre *.go :silent! call CocAction('format')

" Terraform
autocmd! BufWritePre *.tf,*.tfvars
let g:terraform_fmt_on_save=1
let g:terraform_align=1
