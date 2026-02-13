" ==================================================
" init.vim - エントリポイント
" ==================================================
" NOTE: mapleader は basic.vim 内で定義済み

" 基本設定（プラグイン非依存）
source ~/.config/nvim/conf/basic.vim

" プラグイン宣言（vim-plug がインストール済みの場合のみ）
if filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
  source ~/.config/nvim/plugins.vim
endif

" プラグイン個別設定
" NOTE: プラグイン未インストール環境（seed-apply直後等）でのエラーを防ぐため、
"       各プラグインのディレクトリ存在を確認してから読み込む
let s:plugged = expand('~/.local/share/nvim/plugged')

if isdirectory(s:plugged . '/tokyonight.nvim')
  source ~/.config/nvim/conf/colorscheme.vim
endif

if isdirectory(s:plugged . '/lualine.nvim')
  source ~/.config/nvim/conf/lualine.vim
endif

if isdirectory(s:plugged . '/nvim-tree.lua')
  source ~/.config/nvim/conf/nvim-tree.vim
endif

if isdirectory(s:plugged . '/neogit')
  source ~/.config/nvim/conf/git.vim
endif

if isdirectory(s:plugged . '/fzf.vim')
  source ~/.config/nvim/conf/fzf.vim
endif

if isdirectory(s:plugged . '/coc.nvim')
  source ~/.config/nvim/conf/coc.vim
endif
