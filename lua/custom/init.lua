-- My Custom Init for settings I like
-- Folding by indent is nice, without ignoring anything
print 'Setting Foldmethods in nvim/myinit.lua'
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 99
-- vim.opt.foldignore = ''
vim.cmd 'command! DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis'

-- We set the signcolumn to 2 so Errors and writing status can both be shown instead of
-- overwritting each other
vim.opt.signcolumn = 'yes:2'
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.opt.colorcolumn = '100'

vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
-- Just for Documentation
-- Open neo tree with <Alt-Gr -\>
--
vim.keymap.set('n', '<M-r>', vim.lsp.buf.rename, { desc = 'Rename in buffer' })
vim.keymap.set('n', '<leader>n', '<cmd>bn<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>m', '<cmd>bp<CR>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<leader>cc', '<cmd>BufDel<CR>', { desc = 'Delete Buffer' })

vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#c0caf5', bold = true })
vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
}

-- For fugitive adding file to git
vim.keymap.set('n', '<A-a>', function()
  local file = vim.fn.expand '%'
  vim.cmd 'Gwrite'
  print('File added: ' .. file)
end, { desc = 'Add file to git' })

-- Style Breakpoint: Commented it since this styling is done in debug.lua
--vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'red', linehl = '', numhl = '' })
