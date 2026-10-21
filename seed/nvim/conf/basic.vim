" ==================================================
" 基本設定
" ==================================================
set shell=/bin/zsh
set encoding=UTF-8
set clipboard=unnamed
set termguicolors

set shiftwidth=4
set tabstop=2
set expandtab
set textwidth=0
set autoindent

set hlsearch
set splitright

" 行番号・表示系
set number                 " 絶対行番号
set norelativenumber       " 相対行番号オフ
set numberwidth=2
set cursorline
set signcolumn=auto:1


" ==================================================
" 折り返し・スクロール設定
" ==================================================
set nowrap                " 行を折り返さない
set sidescroll=1          " 横スクロールを細かく
set sidescrolloff=5       " 端に余白を持たせる


" ==================================================
" Leader キー
" ==================================================
let mapleader = "\<Space>"


" ==================================================
" ユーティリティ
" ==================================================
" プロジェクトルートからの相対パスをコピー
command! CopyRelativePath let @+ = fnamemodify(expand('%'), ':.')
      \ | echo "Copied: " . fnamemodify(expand('%'), ':.')
nnoremap <leader>y :CopyRelativePath<CR>

" Visual モードで行を上下に移動
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" 今のウィンドウを全面に広げる / 元のレイアウトに戻す
" （ポップアップではなく窓自体を広げるので、vimd のプレビューも広い幅で描き直される）
function! s:toggle_zoom() abort
  if exists('t:zoom_restore')
    execute t:zoom_restore
    unlet t:zoom_restore
  else
    " 戻すときの各ウィンドウの大きさ。タブごとに別々にズームできるよう t: に持つ
    let t:zoom_restore = winrestcmd()
    " 幅（|）と高さ（_）の両方を最大にする
    wincmd |
    wincmd _
  endif
endfunction
nnoremap <silent> <leader>z :<C-u>call <SID>toggle_zoom()<CR>
