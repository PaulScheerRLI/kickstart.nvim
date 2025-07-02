-- local ms = vim.lsp.protocol.Methods
-- local function get_otter_symbols_lang()
--   local otterkeeper = require 'otter.keeper'
--   local main_nr = vim.api.nvim_get_current_buf()
--   local langs = {}
--   for i, l in ipairs(otterkeeper.rafts[main_nr].languages) do
--     langs[i] = i .. ': ' .. l
--   end
--   -- promt to choose one of langs
--   local i = vim.fn.inputlist(langs)
--   local lang = otterkeeper.rafts[main_nr].languages[i]
--   local params = {
--     textDocument = vim.lsp.util.make_text_document_params(),
--     otter = {
--       lang = lang,
--     },
--   }
--   -- don't pass a handler, as we want otter to use its own handlers
--   vim.lsp.buf_request(main_nr, ms.textDocument_documentSymbol, params, nil)
-- end
--

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.dart', '*.md', '*.py', '*.txt' },
  callback = function()
    vim.opt_local.spelllang = { 'en_us', 'de' }
    vim.opt_local.spell = true
  end,
})
-- My Custom Init for settings I like
-- Folding by indent is nice, without ignoring anything
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
vim.o.fillchars = 'fold: '

vim.opt.foldlevel = 99
-- old indent folding
-- vim.opt.foldmethod = 'indent'
-- vim.opt.foldlevel = 99
-- vim.opt.foldnestmax = 99
-- vim.opt.foldignore = ''
if vim.fn.exists ':DiffOrig' == 0 then
  vim.cmd 'command! DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis'
end
-- Duplicate lines by pressing arrow down in normal, inserst or visual mode
vim.keymap.set('n', '<Down>', ':copy . <CR>', { desc = 'Duplicate' })
vim.keymap.set('v', '<Down>', ':copy +0 <CR>', { desc = 'duplicate' })
vim.keymap.set('i', '<Down>', ':copy +0 <CR>i', { desc = 'duplicate' })
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
