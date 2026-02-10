" ==================================================
" プラグイン管理 (vim-plug)
" ==================================================
call plug#begin()

" カラースキーム
Plug 'ntk148v/vim-horizon'
Plug 'folke/tokyonight.nvim'

" ファイル / UI
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ステータスライン / Winbar
Plug 'nvim-lualine/lualine.nvim'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'nvim-lua/plenary.nvim'
Plug 'NeogitOrg/neogit'
Plug 'kdheepak/lazygit.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'f-person/git-blame.nvim'

" 開発支援
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-ts-autotag'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'

" 言語別
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'hashivim/vim-terraform'

call plug#end()
