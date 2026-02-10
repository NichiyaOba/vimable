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


" ==================================================
" カラースキーム設定
" ==================================================
lua << EOF
require("tokyonight").setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
  lsp_semantic_tokens = true,
})
EOF

colorscheme tokyonight

" ==================================================
" lualine（ステータスライン + Winbar）
" ==================================================
lua << EOF
require('lualine').setup({
  options = {
    theme = 'tokyonight',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  winbar = {
    lualine_c = { { 'filename', path = 0 } },
    lualine_x = { 'branch' },
  },
  inactive_winbar = {
    lualine_c = { { 'filename', path = 0 } },
    lualine_x = { 'branch' },
  },
  extensions = { 'nvim-tree', 'fugitive' },
})
EOF


" === nvim-tree Git status 強調 ===
highlight NvimTreeWinSeparator guifg=#888888 guibg=NONE
highlight NvimTreeNormal guibg=NONE
highlight NvimTreeNormalNC guibg=NONE
highlight NvimTreeGitDirty guifg=#ff6c6b gui=bold
highlight NvimTreeGitStaged guifg=#e0af68 gui=bold
highlight NvimTreeGitNew guifg=#9ece6a gui=bold
highlight NvimTreeGitDeleted guifg=#f7768e gui=bold


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
" nvim-tree
" ==================================================
nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
autocmd VimEnter * if argc() == 1 | NvimTreeOpen | endif

lua << EOF
local api = require("nvim-tree.api")

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,

  view = {
    width = 30,
    side = "left",
  },

  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },

  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = {},
  },

  renderer = {
    highlight_git = true,
    highlight_opened_files = "name",
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        git = {
          unstaged = "*",
          staged = "✓",
          untracked = "☆",
          renamed = "➜",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },

  filters = {
    dotfiles = false,
  },

  update_focused_file = {
    enable = true,
    update_root = false,
  },

  actions = {
    open_file = {
      quit_on_open = false,
      window_picker = {
        enable = false,
      },
    },
  },

  on_attach = function(bufnr)
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true }
    end

    -- デフォルトマッピング
    api.config.mappings.default_on_attach(bufnr)

    -- ★ Enter で「右に vertical split で開く」
    vim.keymap.set('n', '<CR>', api.node.open.vertical, opts("Open: Vertical Split"))

    -- 参考（必要なら）
    -- vim.keymap.set('n', 's', api.node.open.horizontal, opts("Open: Horizontal Split"))
    -- vim.keymap.set('n', 't', api.node.open.tab, opts("Open: New Tab"))
  end,
})
EOF

" nvim-treeをリロードするキーマッピングを追加
lua << EOF
local function reload_all()
  local nvim_tree_api = require("nvim-tree.api")

  -- nvim-tree の git キャッシュをクリアしてリロード
  local ok, git = pcall(require, "nvim-tree.git")
  if ok and git.purge_all then
    git.purge_all()
  end

  -- ツリーをリロード
  nvim_tree_api.tree.reload()

  -- 全バッファの GitGutter を更新
  vim.cmd("GitGutterAll")

  -- ファイルの外部変更も検知
  vim.cmd("checktime")

  print("Reloaded: nvim-tree + GitGutter")
end

vim.keymap.set('n', '<leader>r', reload_all, { noremap = true, silent = false })
EOF

" ==================================================
" Git コマンド
" ==================================================
command! Gs Git status
command! Ga Git add %
command! Gc Git commit
command! Gp Git push
command! Gl Git log --oneline --graph --decorate --all
command! Gd Git diff
command! Gds Gdiffsplit!

lua << EOF
require('neogit').setup({
  integrations = { diffview = true },
})
EOF

" Neogit を右 split で開く
nnoremap <leader>gg :Neogit kind=vsplit<CR>

" LazyGit（全画面表示）
lua << EOF
local function open_lazygit()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = vim.o.columns
  local height = vim.o.lines - 1

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = 0,
    col = 0,
    style = 'minimal',
  })

  vim.fn.termopen('lazygit', {
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })
  vim.cmd('startinsert')
end

vim.keymap.set('n', '<leader>lg', open_lazygit, { noremap = true, silent = true })
EOF



" ==================================================
" git-blame.nvim（GitLens風 inline blame）
" ==================================================
let g:gitblame_enabled = 1
let g:gitblame_message_template = '<author> • <summary> • <date>'
let g:gitblame_date_format = '%Y-%m-%d'
let g:gitblame_highlight_group = 'Comment'

" トグル（常時ONだとうるさい時用）
nnoremap <leader>gb :GitBlameToggle<CR>

" ==================================================
" GitGutter（VSCodeライクの塗りつぶしスタイル）
" ==================================================
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▎'
let g:gitgutter_sign_removed_first_line = '▎'
let g:gitgutter_sign_removed_above_and_below = '▎'
let g:gitgutter_sign_modified_removed = '▎'

" 差分出た時のハイライトカラー
highlight GitGutterAdd    guifg=#587c0c ctermfg=2
highlight GitGutterChange guifg=#0c7d9d ctermfg=3
highlight GitGutterDelete guifg=#94151b ctermfg=1

" 変更箇所を移動
nnoremap ]c :GitGutterNextHunk<CR>
nnoremap [c :GitGutterPrevHunk<CR>

" 差分プレビュー（VSCode の hover diff）
nnoremap <leader>hp :GitGutterPreviewHunk<CR>

" 元に戻す
nnoremap <leader>hu :GitGutterUndoHunk<CR>

" ==================================================
" fzf
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


" ==================================================
" Coc / LSP
" ==================================================
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
nnoremap <silent> gr :call <SID>coc_jump_vsplit('jumpReferences')<CR>


nnoremap <silent> <leader>gd :CocFzfList definitions<CR>
nnoremap <silent> <leader>gr :CocFzfList references<CR>
nnoremap <silent> <leader>gi :CocFzfList implementations<CR>


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
