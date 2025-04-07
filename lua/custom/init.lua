-- My Custom Init for settings I like
-- Folding by indent is nice, without ignoring anything
print 'Setting Foldmethods in nvim/myinit.lua'
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 5
--vim.opt.foldnestmax = 99
-- vim.opt.foldignore = ''

vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.opt.colorcolumn = '100'

vim.diagnostic.config {
  virtual_text = false,
  underline = true,
  signs = true,
}
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })

-- Just for Documentation
-- Open neo tree with <Alt-Gr -\>
