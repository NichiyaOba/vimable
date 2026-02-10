" ==================================================
" init.vim - エントリポイント
" ==================================================
" NOTE: mapleader は basic.vim 内で定義済み

" 基本設定（プラグイン非依存）
source ~/.config/nvim/conf/basic.vim

" プラグイン宣言
source ~/.config/nvim/plugins.vim

" プラグイン個別設定
source ~/.config/nvim/conf/colorscheme.vim
source ~/.config/nvim/conf/lualine.vim
source ~/.config/nvim/conf/nvim-tree.vim
source ~/.config/nvim/conf/git.vim
source ~/.config/nvim/conf/fzf.vim
source ~/.config/nvim/conf/coc.vim
