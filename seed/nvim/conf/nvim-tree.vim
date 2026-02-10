" ==================================================
" nvim-tree（ファイルツリー）
" ==================================================

" Git status 強調ハイライト
highlight NvimTreeWinSeparator guifg=#888888 guibg=NONE
highlight NvimTreeNormal guibg=NONE
highlight NvimTreeNormalNC guibg=NONE
highlight NvimTreeGitDirty guifg=#ff6c6b gui=bold
highlight NvimTreeGitStaged guifg=#e0af68 gui=bold
highlight NvimTreeGitNew guifg=#9ece6a gui=bold
highlight NvimTreeGitDeleted guifg=#f7768e gui=bold

" キーマッピング
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

" nvim-tree + GitGutter リロード
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
