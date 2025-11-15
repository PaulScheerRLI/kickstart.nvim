print("hello world from nvim_minimal")

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true


vim.opt.number = true
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
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣'}

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true


-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })



-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--  <ESC><ESC> does not work with tmux. instead we us C-B. In tmux thats <C-B><C-B> since the the first one
--  is escaped
vim.keymap.set('t', '<C-B>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<ESC><ESC>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })



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


-- local function get_nvim_open_level()
--   local Path = require 'plenary.path' -- Requires plenary.nvim
--   local cwd = Path:new(vim.fn.getcwd()):absolute()
--   local level = 0
--
--   for i = 1, 9 do
--     local parent = Path:new(cwd):parent()
--     if parent.filename == cwd.filename then
--       break
--     end
--     cwd = parent
--     level = level + 1
--   end
--
--   return level
-- end
-- local min_level
-- if vim.fn.has 'wsl' == 1 then
--   min_level = 4
-- else
--   min_level = 2
-- end
--
--
-- if get_nvim_open_level() >= min_level then
--   vim.o.path = vim.o.path .. '**'
--   print 'path has been appended with cwd'
-- end



-- this way hovers dont blend so much with the background
vim.o.winborder = 'rounded'
vim.o.exrc = true


--  lets me jump around in zk with gf
vim.o.suffixesadd = vim.o.suffixesadd .. '.md,.html'



-- # Delete into void register in visual mode
vim.keymap.set({ 'x' }, 'D', '"_d')

vim.keymap.set({ 'n' }, '<leader>td', ':lcd %:p:h <CR>', { desc = 'Toggle directory to current file path' })
vim.keymap.set({ 'n' }, '(', '@x', { desc = 'Easy @Access to x Macro' })

-- Set up grep to use vim grep, set the format to properly parse the results to
-- the quickfix/"copen" and fix the shell for windows
vim.opt.grepprg = 'rg --vimgrep'


local python_path = '/usr/bin/python3.10'
-- Check if the file exists
if vim.loop.fs_stat(python_path) then
  vim.g.python3_host_prog = python_path
else
  vim.print 'Python path not found. Using local python instead'
  vim.g.python3_host_prog = 'python'
end


vim.keymap.set({ 'x', 'n' }, '+', '"+y', { desc = 'Yank to plus' })
vim.keymap.set({ 'n' }, 'M', 'm`', { desc = 'Set JuMp. Overrides default jump to mid' })



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

