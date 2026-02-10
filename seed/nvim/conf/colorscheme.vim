" ==================================================
" カラースキーム設定 (tokyonight)
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
