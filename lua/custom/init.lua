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
      -- TODO: maybe unnamedplus for tmux would make sense
      local copy = { 'tmux', 'load-buffer', '-w', '-' }
      local paste = { 'bash', '-c', 'tmux refresh-client -l && tmux save-buffer -' }
      vim.g.clipboard = {
        name = 'tmux',
        copy = {
          ['+'] = copy,
          ['*'] = copy,
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
-- local ts = vim.treesitter
--
-- function getN()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local lang = ts.language.get_lang(vim.bo[bufnr].filetype)
--   local parser = ts.get_parser(bufnr, lang)
--   local tree = parser:parse()[1]
--   local root = tree:root()
--
--   local function print_node(node)
--     local start_row, start_col, end_row, end_col = node:range()
--     print(string.format('Type: %-20s Start: (%d, %d) End: (%d, %d)', node:type(), start_row + 1, start_col + 1, end_row + 1, end_col + 1))
--     for child in node:iter_children() do
--       print_node(child)
--     end
--   end
--
--   print_node(root)
-- end
--
function getText()
  local ts = vim.treesitter
  local api = vim.api

  -- Parse the current buffer using the HTML parser
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = ts.language.get_lang(vim.bo[bufnr].filetype)
  local parser = ts.get_parser(bufnr, lang)
  local tree = parser:parse()[1]
  local root = tree:root()
  print(bufnr)
  print(lang)
  -- Define the Tree-sitter query to capture all text nodes
  -- local query = ts.query.parse(lang, '[[(text) @text]]')
  local query = ts.query.parse(
    lang,
    [[
    (paired_statement) @element
    (raw_html) @raw
    (tag_name) @tag
    (attribute) @attr
    (djangotag) @django_tag
    (django_comment) @django_comment
  ]]
  )
  -- Collect quickfix entries
  local qf_entries = {}
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  print(filepath)
  print(rppt)
  for id, node, metadata in query:iter_captures(root, bufnr, 0, -1) do
    vim.print(node)
    local name = query.captures[id] -- name of the capture, like "function" or "name"
    local sr, sc, er, ec = node:range()
    local text = ts.get_node_text(node, bufnr)
    -- Skip empty or whitespace-only text nodes
    if text:match '%S' then
      table.insert(qf_entries, {
        bufnr = bufnr,
        lnum = sr + 1,
        col = sc + 1,
        text = text,
      })
    end
  end

  ---     bufnr  buffer number; must be the number of a valid
  ---     buffer
  ---     filename  name of a file; only used when "bufnr" is not
  ---     present or it is invalid.
  ---     module  name of a module; if given it will be used in
  ---     quickfix error window instead of the filename.
  ---     lnum  line number in the file
  ---     end_lnum  end of lines, if the item spans multiple lines
  ---     pattern  search pattern used to locate the error
  ---     col    column number
  ---     vcol  when non-zero: "col" is visual column
  ---     when zero: "col" is byte index
  ---     end_col  end column, if the item spans multiple columns
  ---     nr    error number
  ---     text  description of the error
  ---     type  single-character error type, 'E', 'W', etc.
  ---     valid  recognized error message
  ---     user_data
  ---     custom data associated with the item, can be
  ---     any type.
  -- Set the quickfix list and open it
  vim.fn.setqflist(qf_entries, 'r')
  vim.cmd 'copen'
end
--
--
function print_query_nodes(query_str, lang)
  local ts = vim.treesitter
  local bufnr = vim.api.nvim_get_current_buf()
  lang = lang or ts.language.get_lang(vim.bo[bufnr].filetype)
  local parser = ts.get_parser(bufnr, lang)
  local tree = parser:parse()[1]
  local root = tree:root()
  print(root)
  local query = vim.treesitter.query.parse(lang, query_str)

  for id, node, metadata in query:iter_captures(root, bufnr, 0, -1) do
    vim.print(metadata)
    local name = query.captures[id] -- name of the capture, like "function" or "name"
    local sr, sc, er, ec = node:range()
    print(string.format('Capture: %-15s Type: %-20s Range: (%d, %d) - (%d, %d)', name, node:type(), sr + 1, sc + 1, er + 1, ec + 1))
    print(ts.get_node_text(node, bufnr))
  end
  print 'finished'
end

local ts = vim.treesitter

function query_all_injected_trees(query)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = ts.get_parser(bufnr)
  local trees = { parser:parse()[1] }

  -- Also include all injected trees (html, javascript, etc.)
  all_trees = {}

  -- Add main tree
  for _, tree in ipairs(parser:parse()) do
    print 'main'
    print(parser:lang())
    table.insert(all_trees, { tree = tree, lang = parser:lang() })
  end

  -- Add injected trees manually
  function addChildren(parser)
    for key, child in pairs(parser:children()) do
      print 'child.lang'
      print(child:lang())
      for _, tree in pairs(child:parse()) do
        print 'found tree'
        table.insert(all_trees, { tree = tree, lang = child:lang() })
      end
      addChildren(child)
    end
  end

  addChildren(parser)

  for _, tree_data in ipairs(all_trees) do
    local tree = tree_data.tree
    local lang = tree_data.lang
    local root = tree:root()
    -- Query example: get all text and element nodes from any tree
    local ok, query = pcall(function()
      return ts.query.parse(lang, [[    (text) @text    (element) @element  ]])
    end)
    if ok then
      for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
        local name = query.captures[id]
        local sr, sc, er, ec = node:range()
        local ok, text = pcall(ts.get_node_text, node, bufnr)
        print(
          string.format(
            'Capture: %-10s Type: %-15s Text: %.40s (%d:%d - %d:%d)',
            name,
            node:type(),
            ok and text:gsub('\n', '\\n') or '[unavailable]',
            sr + 1,
            sc + 1,
            er + 1,
            ec + 1
          )
        )
      end
    end
  end
  print 'end'
end
