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
