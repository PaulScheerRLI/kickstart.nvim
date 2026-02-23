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

-- use local .nvim.lua for project configs
vim.o.exrc = true
vim.o.secure = true

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
  print 'path has been appended with cwd'
end
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
-- NOTE: This destroys python diffing when tabbing
-- vim.o.diffopt = vim.o.diffopt .. ',iwhiteall'
vim.o.diffopt = vim.o.diffopt

-- # Delete into void register in visual mode
vim.keymap.set({ 'x' }, 'D', '"_d')

vim.keymap.set({ 'n' }, '<leader>td', ':lcd %:p:h <CR>', { desc = 'Toggle directory to current file path' })
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

vim.opt.signcolumn = 'yes:1'
-- sets the minimum amount of numbers
local tokyonight_moon = require 'lualine.themes.tokyonight' -- Change the background of inactive lualine/statusline to slightly darker

vim.api.nvim_set_hl(0, 'StatusBorder', { bg = tokyonight_moon.inactive.c.bg })

-- Change the background of inactive lualine/statusline to slightly darker
--'%#StatusBorder#%'
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . ' ' : v:lnum) : ''}%s│%T"
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? @SignCb@%s : v:lnum) : ''}%=│%T"
-- vim.opt.statuscolumn = '%s%=%l│'

-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s│%T"
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
-- statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s│%T"
vim.print 'status col set in custom.init'
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '' : v:lnum) : ''}%"
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

local ts = vim.treesitter
function getTSCaptures(query, bufnr)
  -- Temporarily open the buffer in a window. This is needed since injected languages are only detected when opening the file.
  -- kinda strange behvaioru
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd 'keepalt silent belowright split'
  local tmp_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(tmp_win, bufnr)

  local parser = ts.get_parser(bufnr)
  local trees = { parser:parse()[1] }
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local all_trees = {}

  -- Add main tree
  for _, tree in ipairs(parser:parse()) do
    table.insert(all_trees, { tree = tree, lang = parser:lang() })
  end

  -- Add injected trees manually
  local function addChildren(parser)
    for key, child in pairs(parser:children()) do
      for _, tree in pairs(child:parse()) do
        table.insert(all_trees, { tree = tree, lang = child:lang() })
      end
      addChildren(child)
    end
  end
  addChildren(parser)

  -- the children/ injected languages are detected. close window again
  vim.api.nvim_win_close(tmp_win, true)
  vim.api.nvim_set_current_win(cur_win)

  local qf_entries = {}
  for _, tree_data in ipairs(all_trees) do
    local tree = tree_data.tree
    local lang = tree_data.lang
    local root = tree:root()
    -- Query example: get all text and element nodes from any tree
    local ok, query = pcall(function()
      return ts.query.parse(lang, query)
    end)
    if ok then
      for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
        -- print 'found'
        -- local name = query.captures[id]
        -- local sr, sc, er, ec = node:range()
        table.insert(qf_entries, node)
      end
    else
      -- print 'not ok'
      -- print(lang)
      -- ts.query.parse(lang, query)
    end
  end
  return qf_entries, all_trees
end
function query_all_injected_trees(query, quicklist_method)
  assert(quicklist_method == 'r' or quicklist_method == 'a' or quicklist_method == 'f' or quicklist_method == ' ' or quicklist_method == nil)
  quicklist_method = quicklist_method or 'r'

  if query == nil or query == '' then
    error 'Pass a query like [[(text) @text]] to the function. quotes around query are optional.'
  end
  local bufnr = vim.api.nvim_get_current_buf()
  print(query)

  nodes, all_trees = getTSCaptures(query, bufnr)
  if next(nodes) == nil then
    vim.print(filename)
    vim.print 'No matches found. The following languages where searched'
    local langs = {}
    for key, value in pairs(all_trees) do
      table.insert(langs, value.lang)
    end
    vim.print(langs)
    return
  end
  qf_entries = {}
  for _, node in ipairs(nodes) do
    local sr, sc, er, ec = node:range()
    local ok, text = pcall(ts.get_node_text, node, bufnr)
    table.insert(qf_entries, {
      bufnr = bufnr,
      lnum = sr + 1,
      end_lnum = er + 1,
      col = sc + 1,
      end_col = ec + 1,
      text = text,
    })
  end
  vim.fn.setqflist(qf_entries, quicklist_method)
end

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

local function select_current_qf_item()
  local qf_list = vim.fn.getqflist()
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  local item = qf_list[idx]

  if not item or not item.bufnr or item.bufnr == 0 then
    return
  end

  local bufnr = item.bufnr
  local start_lnum = item.lnum
  local start_col = item.col
  local end_lnum = item.end_lnum or item.lnum
  local end_col = item.end_col - 1 or (item.col + 1)
  -- Switch to the buffer and move the cursor
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(0, { start_lnum, start_col - 1 })

  -- Use visual selection to select the range
  vim.cmd 'normal! v'
  vim.api.nvim_win_set_cursor(0, { end_lnum, math.max(end_col - 1, 0) })
end

vim.api.nvim_create_user_command('QueryTS', function(opts)
  -- example call
  --QueryTS [[(text) @text]] -f
  local query = opts.args
  local flag = string.match(query, '%-(%a)')
  if flag then
    local cleaned = string.gsub(query, '%-' .. flag, '', 1)
    query = vim.trim(cleaned)
  end
  query_all_injected_trees(query, flag)
end, { nargs = 1 })
vim.api.nvim_create_user_command('SelectQuickList', select_current_qf_item, {})
vim.api.nvim_create_user_command('Clearquickfix', function()
  vim.fn.setqflist({}, ' ')
end, {})
