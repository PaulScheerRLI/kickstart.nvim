local start_time = vim.uv.hrtime()
local function get_nvim_open_level()
  local Path = require 'plenary.path' -- Requires plenary.nvim
  local cwd = Path:new(vim.fn.getcwd()):absolute()
  local level = 0

  for i = 1, 9 do
    local parent = Path:new(cwd):parent()
    if parent.filename == cwd.filename then
      break
    end
    cwd = parent
    level = level + 1
  end

  return level
end
local min_level
if vim.fn.has 'wsl' == 1 then
  min_level = 4
else
  min_level = 2
end

-- this way hovers dont blend so much with the background
vim.o.winborder = 'rounded'

-- continue with comments when pressing enter
vim.opt.formatoptions:append 'r'

-- use local .nvim.lua for project configs
vim.o.exrc = true
vim.o.secure = true

-- When using completefunctions like c-x c-o the first item is selected. Instead we dont select
--   anything so typing still changes and reduces the complete suggestions.
--   NOTE: the normal full mode would need to cycle back to empty suggestion with C-p and then tpye
vim.opt.completeopt = 'menuone,noinsert,popup'

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { 'dbui' },
  callback = function()
    vim.o.tabstop = 1
    vim.o.shiftwidth = 1
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*' },
  callback = function()
    if vim.bo.filetype == 'dbui' then
      return
    end
    -- vim.o.tabstop = 2
    -- vim.o.shiftwidth = 2
    -- vim.o.expandtab = true
  end,
})
--  lets me jump around in zk with gf
vim.o.suffixesadd = vim.o.suffixesadd .. '.md,.html'

-- for better goFile with python file / line number combos based on
-- https://github.com/sychen52/gF-python-traceback
-- the function is in  autoload/pythongF
-- vim.keymap.set({ 'n' }, 'gF', '<Cmd>call pythongF#gF()<CR>', { desc = 'go  to File with python formatting' })

if get_nvim_open_level() >= min_level then
  vim.o.path = vim.o.path .. '**'
  -- vim.print 'path has been appended with cwd'
      require('fidget').notification.notify('custom/init.lua', vim.log.levels.INFO, { annote = ('path appebded')})
end
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
-- NOTE: This destroys python diffing when tabbing
-- vim.o.diffopt = vim.o.diffopt .. ',iwhiteall'
vim.o.diffopt = vim.o.diffopt

-- # Delete into void register in visual mode
vim.keymap.set({ 'x' }, 'D', '"_d')
------------------------------------------
---Custom text object
-- vim.keymap.set({ 'o' }, 'ikkk', ":normal vik<CR>", {silent=true})
-- vim.keymap.set({ 'x' }, 'ikkk', function()
--   vim.api.nvim_buf_set_mark(0,'[', 77,0)
--   vim.api.nvim_buf_set_mark(0,']', 77,10)
--   -- in visual mode go to the exact (`) location of mark [ then switch cursor position of selection
--   -- from start to end. move the end of the selection to mark ]
--   return "`[o`]"
-- end, {expr=true})

-- # easy selectin increase
vim.keymap.set({ 'x' }, 'v', function()
  vim.api.nvim_feedkeys('an', 'v', false)
end)
vim.keymap.set({ 'x' }, 'V', function()
  vim.api.nvim_feedkeys('in', 'v', false)
end)

-- Select/ Highlight whole buffer. First Step in yank whole buffer, and delete whole buffer, but also
--   replace whole buffer
-- vim.keymap.set({ 'n' }, '<M-a>', "m'goVG")
-- use nvim 0.13 al motion instead val

vim.keymap.set({ 'n' }, '<leader>td', function()
  local root_markers = {
    'manage.py',
    'pyproject.toml',
    'requirements.txt',
    '.git',
  }
  -- use vim.w for window specific values
  local assumed_root = vim.fs.root(0, root_markers)
  local current_dir = vim.fn.getcwd()
  if assumed_root == current_dir then
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
    vim.fn.chdir(path, 'window')
    require('fidget').notification.notify('custom/init.lua', vim.log.levels.INFO, { key = 'pauls_toggle_dir', annote = 'Toggle cd of Window to current file' })
    return
  else
    vim.fn.chdir(assumed_root, 'window')
    require('fidget').notification.notify(
      'custom/init.lua',
      vim.log.levels.INFO,
      { key = 'pauls_toggle_dir', annote = (('Toggle cd of window to assumed root: %s'):format(assumed_root)) }
    )
    return
  end
end, { desc = 'Toggle dir of window between file/assumed_root' })

vim.keymap.set({ 'n' }, '(', '@x', { desc = 'Easy @Access to x Macro' })

-- Set up grep to use vim grep, set the format to properly parse the results to
-- the quickfix/"copen" and fix the shell for windows
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'
if vim.fn.has 'windows' == 1 and vim.fn.has 'wsl' == 0 then
  -- nvim uses a package called tee for piping which does not come with windows
  vim.o.shellpipe = '>%s 2>&1'
end

local python_path = '/home/ubuntu/.pyenv/versions/neovim/bin/python'
local python_path = '/usr/bin/python3.10'
-- Check if the file exists
if vim.loop.fs_stat(python_path) then
  vim.g.python3_host_prog = python_path
else
  vim.print 'Python path not found. Using local python instead'
  vim.g.python3_host_prog = 'python'
end
-- for better pasting in tmux remap + to yank to + register

vim.keymap.set({ 'x', 'n' }, '+', '"+y', { desc = 'Yank to plus' })
vim.keymap.set({ 'n' }, 'M', 'm`', { desc = 'Set JuMp. Overrides default jump to mid' })

-- Insta completion from buffer using next or previous match
vim.keymap.set('i', '<C-G>', '<C-X><C-N>', { desc = 'Complete with upcoming matches' })
vim.keymap.set('i', '<C-F>', '<C-X><C-P>', { desc = 'Complete with previous matches' })

vim.keymap.set('n', '<leader>rr', ':%s/', { desc = 'Enter Replace/Substition' })

local vimrc = vim.fn.stdpath 'config' .. '/vimrc.vim'

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

vim.cmd.source(vimrc)
-- without this nvim copy pasting to inside tmux to tmux terminals or windows did now work
-- from https://github.com/neovim/neovim/discussions/29350
-- standard clipboard behaviour
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
  if vim.fn.has 'wsl' == 1 then
    -- with this doesn use + and * register by default calling win32yank each time
    -- it also means that to copy paste outside we need to explicitly call the register
    -- i find this better for now since mostly i dont copy  paste from nvim to outside
    --
    vim.opt.clipboard = ''
    -- vim.opt.clipboard = 'unnamedplus'
    -- also slow
    --
    vim.g.clipboard = {
      name = 'win32yank-wsl',
      copy = {
        ['+'] = 'win32yank.exe -i --crlf',
        ['*'] = 'win32yank.exe -i --crlf',
      },
      paste = {
        ['+'] = 'win32yank.exe -o --lf',
        ['*'] = 'win32yank.exe -o --lf',
      },
      cache_enabled = 1,
    }
    -- from vim help clipboard-wsl
    --
    -- works but is very slow
    -- vim.g.clipboard = {
    --   name = 'WslClipboard',
    --   copy = {
    --     ['+'] = 'clip.exe',
    --     ['*'] = 'clip.exe',
    --   },
    --   paste = {
    --     ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --     ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --   },
    -- }
    if vim.env.TMUX ~= nil then
      vim.opt.clipboard = 'unnamedplus'
      vim.g.clipboard = 'tmux'
      -- vim.g.clipboard = {
      --   name = 'tmux',
      --   copy = {
      --     ['+'] = 'clip.exe',
      --     ['*'] = 'clip.exe',
      --   },
      --   paste = {
      --     ['+'] = paste,
      --     ['*'] = paste,
      --   },
      --   cache_enabled = 0,
      -- }
    end
  end
end)
-- Idea from nvim help
-- use + register to paste tp clip.exe. this enables pasting in windows
-- from windows im using ctrl-v anyways which works fine
-- to paste in nvim we can override both paste to use foo. i dont use * differently anyways
-- vim.g.clipboard = {
--   name = 'myClipboard',
--   copy = {
--     ['+'] = 'clip.exe',
--     ['*'] = function(lines, regtype)
--       vim.g.foo = { lines, regtype }
--     end,
--   },
--   paste = {
--     ['+'] = function()
--       return vim.g.foo or {}
--     end,
--     ['*'] = function()
--       return vim.g.foo or {}
--     end,
--   },
-- }

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.dart', '*.md', '*.py', '*.txt', '*COMMIT_EDITMSG' },
  callback = function()
    -- // de_20 is german with new spelling
    vim.opt_local.spelllang = { 'en_us', 'de_20' }
    vim.opt_local.spell = true
  end,
})
-- My Custom Init for settings I like
-- Folding by indent is nice, without ignoring anything
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- set foldexpr=nvim_treesitter#foldexpr()
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
-- NOTE: Disabled
-- vim.keymap.set('n', '<Down>', ':copy . <CR>', { desc = 'Duplicate' })
-- vim.keymap.set('v', '<Down>', ':copy +0 <CR>', { desc = 'duplicate' })
-- vim.keymap.set('i', '<Down>', ':copy +0 <CR>i', { desc = 'duplicate' })
-- We set the signcolumn to 2 so Errors and writing status can both be shown instead of
-- overwritting each other
--
-- -- The name should be unique so that it doesn't overwrite one of the default highlight group
c = require 'tokyonight.colors.night'
vim.api.nvim_set_hl(0, 'InActive', { bg = c.bg })
vim.api.nvim_create_autocmd('WinLeave', {
  group = vim.api.nvim_create_augroup('InActiveHl', { clear = true }),
  callback = function()
    vim.wo.winhl = 'cursorline:InActive'
  end,
})
vim.api.nvim_create_autocmd('WinEnter', {
  group = vim.api.nvim_create_augroup('ActiveHl', { clear = true }),
  callback = function()
    vim.wo.winhl = 'InActive:cursorline'
  end,
})

-- sets the minimum amount of numbers
vim.opt.signcolumn = 'yes:1'


local tokyonight_moon = require 'lualine.themes.tokyonight' -- Change the background of inactive lualine/statusline to slightly darker
vim.api.nvim_set_hl(0, 'StatusBorder', { bg = tokyonight_moon.inactive.c.bg })
local tokyonight = require 'lualine.themes.tokyonight' -- Change the background of inactive lualine/statusline to slightly darker

-- for netwr
vim.g.netrw_winsize = 20
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- set last entrance to relativenumver, the rest are defaults
vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'

vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.opt.colorcolumn = '100'

vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
-- Just for Documentation
-- Open neo tree with <Alt-Gr -\>
--
-- this is done with the lsp setup - grn
-- vim.keymap.set('n', '<M-r>', vim.lsp.buf.rename, { desc = 'Rename in buffer' })
-- this is done by [b   ]b
-- vim.keymap.set('n', '<leader>n', '<cmd>bn<CR>', { desc = 'Next Buffer' })
-- vim.keymap.set('n', '<leader>m', '<cmd>bp<CR>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<leader>w', function()
  vim.cmd 'noautocmd write'
end, { desc = 'Write Buffer' })
vim.keymap.set('n', '<leader>cc', function()
  vim.cmd 'BufDel'
end, { desc = 'Delete Buffer' })

vim.keymap.set('n', '<leader>w', function()
  vim.cmd 'noautocmd write'
end, { desc = 'Quick write without autocommands/formating' })

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

local function unique(list)
  local seen = {}
  local result = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      seen[v] = true
      table.insert(result, v)
    end
  end

  return result
end

vim.api.nvim_create_user_command('OpenDir', ':!explorer.exe $(wslpath -w %:p:h)', {})
vim.api.nvim_create_user_command('OpenFile', ':!explorer.exe $(wslpath -w %:p)', {})

vim.api.nvim_create_user_command('FilterWithoutDelete', function(opts)
  local l1, l2 = opts.line1, opts.line2
  local delta = l2 - l1 + 1
  local cmd = table.concat(opts.fargs, ' ')
  -- yank
  vim.cmd(string.format('%d,%dyank', l1, l2))
  -- put above
  vim.cmd(string.format('%dput!', l1))
  -- run provided filter command
  vim.cmd(string.format('%d,%d!%s', l1 + delta, l2 + delta, cmd))
end, {
  range = true,
  nargs = '+',
})

vim.api.nvim_create_user_command('MessagesToBuffer', function()
  local messages = vim.fn.execute 'messages'
  local lines = vim.split(messages, '\n')

  vim.cmd 'new'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
end, {})

vim.schedule(function()
  require('vim._core.ui2').enable {
    enable = true, -- Whether to enable or disable the UI.
    msg = { -- Options related to the message module.
      ---@type 'cmd'|'msg' Default message target, either in the
      ---cmdline or in a separate ephemeral message window.
      ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
      ---or table mapping |ui-messages| kinds and triggers to a target.
      targets = 'cmd',
      cmd = { -- Options related to messages in the cmdline window.
      },
      maxheight = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
      dialog = { -- Options related to dialog window.
        height = 0.5, -- Maximum height.
      },
      msg = { -- Options related to msg window.
      },

      timeout = 4000, -- Time a message is visible in the message window.
      pager = { -- Options related to message window.
        height = 40, -- Maximum height.
      },
    },
  }
end)

-- Instead of jumping to the file jump to the file and go to the last exit of the buffer
local function remap_uppercase_marks()
  for i = string.byte 'A', string.byte 'Z' do
    local mark = string.char(i)
    vim.keymap.set('n', "'" .. mark, function()
      vim.cmd("normal! '" .. mark)
      vim.cmd [[normal! '"]]
    end, { noremap = true, silent = true })
  end
end

remap_uppercase_marks()

vim.filetype.add {
  extension = {
    script = 'myscript',
  },
}

-- Bookmark system
-- bookmarks.txt in ~/bookmarks.txt
bookmark_path = '~/bookmarks.txt'
vim.api.nvim_create_user_command('MarkBookmark', function()
  local path = vim.fn.expand '%:p:h'
  local bpath = vim.fn.expand(bookmark_path)
  vim.fn.system('grep -qF ' .. vim.fn.shellescape(path) .. ' ' .. vim.fn.shellescape(bpath))
  if vim.v.shell_error ~= 0 then
    vim.fn.system('echo ' .. vim.fn.shellescape(path) .. ' >> ' .. vim.fn.shellescape(bpath))
    print 'added'
  else
    print 'exists already'
  end
end, {})

vim.api.nvim_create_user_command('GoBookmark', function(opts)
  local path = opts.args
  if path ~= '' then
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
  end
end, {
  nargs = 1,
  complete = function()
    local bpath = vim.fn.expand(bookmark_path)
    if vim.fn.filereadable(bpath) == 0 then
      return {}
    end
    return vim.fn.readfile(bpath)
  end,
})

vim.api.nvim_create_user_command('ClearMulticursor', function()
  local mc_ns = vim.api.nvim_create_namespace 'nvim.multicursor'
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end, { desc = 'clear multicursor' })

vim.api.nvim_create_user_command('EditWindowsPath', function(opts)
  local path = opts.args
  local result = vim.system({ 'wslpath', path }):wait()
  local wslpath = vim.trim(result.stdout)
  if wslpath ~= '' then
    vim.cmd('edit ' .. vim.fn.fnameescape(wslpath))
  end
end, {
  nargs = 1,
})

-- tresitter highlighting can be very slow in insert mode.
-- this uses an autocommand when switching modes to turn off treesitter in insert mode for a smoother
-- typing experience. When going back to other modes treesitter is started again.
-- a guard stops treesitter from starting when already started
local ts_active = nil
vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('enable-treesitter-in-normal-mode', { clear = true }),
  pattern = { '*:n', '*:o', '*:v' },
  callback = function()
    -- only activate if the parser exists
    local parser = vim.treesitter.get_parser(0, nil, { error = false })
    if not ts_active and parser then
      local start = vim.uv.hrtime()
      vim.treesitter.start()
      ts_active = true
      local elapsed = (vim.uv.hrtime() - start) / 1e6
      require('fidget').notification.notify('custom/init.lua', vim.log.levels.INFO, { annote = ('TS Restarted in %.3f ms'):format(elapsed) })
    end
  end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('disable-treesitter-in-inser-mode', { clear = true }),
  pattern = { '*:i' },
  callback = function()
    vim.treesitter.stop()
    ts_active = false
  end,
})

require 'custom.pauls.completfunc'
require 'custom.pauls.edit_location_list'
require 'custom.pauls.query_treesitter'
require 'custom.pauls.substitute'
require 'custom.pauls.django_helpers'
require 'custom.pauls.multicursor'

local end_time = vim.uv.hrtime()
-- vim.print((end_time-start_time)/10^6)
