vim.notify 'Using min_init.lua with minimal configuration'
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
----
---------- SETTINGS
---------------------------------------------------------------
---------------------------------------------------------------
if vim.fn.has 'wsl' == 1 then
vim.api.nvim_create_user_command('CDCONFIG', function()
  vim.cmd("cd ~/.config/nvim/")
  vim.cmd("e ~/.config/nvim/init.lua")
  end, {})

vim.api.nvim_create_user_command('CDCONFIGSNACKS', function()
  vim.cmd("cd ~/.config/nvim_snacks/")
  vim.cmd("e ~/.config/nvim_snacks/init.lua")
  end, {})
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.opt.number = true

vim.o.termguicolors = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = true
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Decrease update time for swap file
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time in ms for keymaps
vim.opt.timeoutlen = 150
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- this way hovers dont blend so much with the background
vim.o.winborder = 'rounded'
vim.o.exrc = true

--Tabstops
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

--  lets me jump around in zk with gf and html
vim.o.suffixesadd = vim.o.suffixesadd .. '.md,.html'

-- For fuzzy finding of all files in the subdirectory
-- Its a bad setting for big folders/root of the drive
-- Maybe better set it manually and mksession
-- vim.o.path = vim.o.path '**'

-- Set up grep to use vim grep, set the format to properly parse the results to
-- the quickfix/"copen" and fix the shell for windows
vim.opt.grepprg = 'rg --vimgrep'

-- NOTE: needed?
-- local python_path = '/usr/bin/python3.10'
-- -- Check if the file exists
-- if vim.loop.fs_stat(python_path) then
--   vim.g.python3_host_prog = python_path
-- else
--   vim.print 'Python path not found. Using local python instead'
--   vim.g.python3_host_prog = 'python'
-- end

vim.api.nvim_set_hl(1, 'WinSeparator', { bold = true })
vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
}

----
---------- KEYMAPS
---------------------------------------------------------------
---------------------------------------------------------------

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--  <ESC><ESC> does not work with tmux. instead we us C-B. In tmux thats <C-B><C-B> since the the first one
--  is escaped
vim.keymap.set('t', '<C-B>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<ESC><ESC>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- # Delete into void register in visual mode
vim.keymap.set({ 'x' }, 'D', '"_d')
vim.keymap.set({ 'n' }, '<leader>w', '<cmd>noautocmd write<CR>')

vim.keymap.set({ 'n' }, '<leader>td', ':lcd %:p:h <CR>', { desc = 'Toggle directory to current file path' })

vim.keymap.set({ 'x', 'n' }, '+', '"+y', { desc = 'Yank to plus' })
-- vim.keymap.set({ 'n' }, 'M', 'm`', { desc = 'Set JuMp. Overrides default jump to mid' })

----
---------- AUTOCOMMANDS
---------------------------------------------------------------
---------------------------------------------------------------
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit positon when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('SaveCursorPos', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.dart', '*.md', '*.py', '*.txt', '*COMMIT_EDITMSG' },
  callback = function()
    -- // de_20 is german with new spelling
    vim.opt_local.spelllang = { 'en_us', 'de_20' }
    vim.opt_local.spell = true
  end,
})

vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

----
---------- PACKAGES (nvim >=0.11)
---------------------------------------------------------------
---------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim.git" },
  { src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup()

vim.cmd("colorscheme tokyonight-night")

vim.lsp.enable({"lua_ls"})
vim.lsp.enable({"pyright"})

vim.cmd[[set completeopt+=menuone,noselect,popup]]
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    print('lspattach')
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      local chars = {}; for i = 65, 122 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
      print('completion enabled')
    end
    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    -- if not client:supports_method('textDocument/willSaveWaitUntil')
    --     and client:supports_method('textDocument/formatting') then
    --   vim.api.nvim_create_autocmd('BufWritePre', {
    --     group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
    --     buffer = args.buf,
    --     callback = function()
    --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
    --     end,
    --   })
    -- end
  end,
})
