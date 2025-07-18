vim.o.path = vim.o.path .. '**'
vim.o.diffopt = vim.o.diffopt .. ',iwhiteall'
vim.keymap.set({ 'n' }, '<leader>td', ':lcd %:p:h <CR>', { desc = 'Toggle directory to current file path' })
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'
local python_path = '/home/ubuntu/.pyenv/versions/neovim/bin/python'
-- Check if the file exists
if vim.loop.fs_stat(python_path) then
  vim.g.python3_host_prog = python_path
else
  vim.print 'Python path not found. Using local python instead'
  vim.g.python3_host_prog = 'python'
end
-- for better pasting in tmux remap + to yank to + register

vim.keymap.set({ 'x', 'n' }, '+', '"+y', { desc = 'Yank to plus' })

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
      local copy = { 'tmux', 'load-buffer', '-w', '-' }
      local paste = { 'bash', '-c', 'tmux refresh-client -l && tmux save-buffer -' }
      vim.g.clipboard = {
        name = 'tmux',
        copy = {
          ['+'] = 'clip.exe',
          ['*'] = 'clip.exe',
        },
        paste = {
          ['+'] = paste,
          ['*'] = paste,
        },
        cache_enabled = 0,
      }
    end
  end
end)
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
vim.keymap.set('n', '<Down>', ':copy . <CR>', { desc = 'Duplicate' })
vim.keymap.set('v', '<Down>', ':copy +0 <CR>', { desc = 'duplicate' })
vim.keymap.set('i', '<Down>', ':copy +0 <CR>i', { desc = 'duplicate' })
-- We set the signcolumn to 2 so Errors and writing status can both be shown instead of
-- overwritting each other
--
-- vim.opt.signcolumn = 'yes:1'
vim.opt.numberwidth = 3
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"

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

local ts = vim.treesitter

function query_all_injected_trees(query, quicklist_method)
  assert(quicklist_method == 'r' or quicklist_method == 'a' or quicklist_method == 'f' or quicklist_method == ' ' or quicklist_method == nil)
  quicklist_method = quicklist_method or 'r'

  if query == nil or query == '' then
    error 'Pass a query like [[(text) @text]] to the function. quotes around query are optional.'
  end
  local bufnr = vim.api.nvim_get_current_buf()

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
        local name = query.captures[id]
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
    end
  end
  if next(qf_entries) == nil then
    vim.print(filename)
    vim.print 'No matches found. The following languages where searched'
    local langs = {}
    for key, value in pairs(all_trees) do
      table.insert(langs, value.lang)
    end
    vim.print(langs)
    return
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
