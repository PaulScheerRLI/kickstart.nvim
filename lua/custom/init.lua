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
-- vim.keymap.set('n', '<leader>os', get_otter_symbols_lang, { desc = 'otter [s]ymbols' }) -- Enable Spell check
-- --- This code will run whenever you enter insert mode...
-- vim.api.nvim_create_autocmd('InsertEnter', {
--   group = vim.api.nvim_create_augroup('otter-autostart', {}),
--   -- ...But this only runs in markdown and quarto documents
--   pattern = { '*.md', '*.qmd' },
--   callback = function()
--     -- Get the treesitter parser for the current buffer
--     local ok, parser = pcall(vim.treesitter.get_parser)
--     if not ok then
--       return
--     end
--
--     local otter = require 'otter'
--     local extensions = require 'otter.tools.extensions'
--     local attached = {}
--
--     -- Get the language for the current cursor position (this will be
--     -- determined by the current code chunk if that's where the cursor
--     -- is)
--     local line, col = vim.fn.line '.' - 1, vim.fn.col '.'
--     local lang = parser:language_for_range({ line, col, line, col + 1 }):lang()
--
--     -- If otter has an extension available for that language, and if
--     -- the LSP isn't already attached, then activate otter for that
--     -- language
--     if extensions[lang] and not vim.tbl_contains(attached, lang) then
--       table.insert(attached, lang)
--       vim.schedule(function()
--         otter.activate({ lang }, true, true)
--       end)
--     end
--   end,
-- })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.dart', '*.md', '*.py', '*.txt' },
  command = 'setlocal spell',
})
-- My Custom Init for settings I like
-- Folding by indent is nice, without ignoring anything
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
