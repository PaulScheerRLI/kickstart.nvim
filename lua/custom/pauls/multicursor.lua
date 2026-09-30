vim.keymap.set({ 'x', 'n' }, '<leader>*', function()
  local mode = vim.fn.mode() == 'n' and 'n' or 'x'
  -- make sure to feed the * in the current mode, since normal mode "*" acts differently than x mode "*"
  vim.api.nvim_feedkeys('*', mode, false)
  -- need to wait for processing of nvim_feedkeys it seems
  vim.schedule(function()
    vim.cmd 'normal!1Qq='
    vim.cmd 'nohlsearch'
  end)
end, { desc = 'Set multicursor on all matches for current word or selection' })

vim.keymap.set('n', { '<Esc>', '<M-q>' }, function()
    vim.cmd('nohlsearch')
  local mc_ns = vim.api.nvim_create_namespace 'nvim.multicursor'
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end, { noremap = true, desc = 'Clear all multicursors' })

--
-- Reset old Q behavior of replaying last recordec macro
vim.keymap.set('n', 'Q', function()
  local reg = vim.fn.reg_recorded()
  return reg == '' and '' or ('@' .. reg)
end, { expr = true })

vim.keymap.set('x', 'Q', "mode() ==# 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>' : 'Q'", { silent = true, expr = true, desc = ':help v_Q-default' })
