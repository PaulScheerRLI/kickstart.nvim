-- For fugitive adding file to git
vim.keymap.set('n', '<leader>ag', function()
  local file = vim.fn.expand '%'
  vim.cmd 'Gwrite'
  print('File added to git: ' .. file)
end, { desc = '<leader> [A]dd file to [g]it' })
return { 'tpope/vim-fugitive' }
