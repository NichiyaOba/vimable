
" ==================================================
" Git 系プラグイン設定
" ==================================================

" --- Git コマンド ---
command! Gs Git status
command! Ga Git add %
command! Gc Git commit
command! Gp Git push
command! Gl Git log --oneline --graph --decorate --all
command! Gd Git diff
command! Gds Gdiffsplit!


" --- Neogit ---
lua << EOF
require('neogit').setup({
  integrations = { diffview = true },
})
EOF

" Neogit を右 split で開く
nnoremap <leader>gg :Neogit kind=vsplit<CR>


" --- LazyGit（全画面表示）---
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

vim.keymap.set('n', '<leader>lk', open_lazygit, { noremap = true, silent = true })
EOF


" --- git-blame.nvim（GitLens風 inline blame）---
let g:gitblame_enabled = 1
let g:gitblame_message_template = '<author> • <summary> • <date>'
let g:gitblame_date_format = '%Y-%m-%d'
let g:gitblame_highlight_group = 'Comment'

" トグル（常時ONだとうるさい時用）
nnoremap <leader>gb :GitBlameToggle<CR>


" --- GitGutter（VSCodeライクの塗りつぶしスタイル）---
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
