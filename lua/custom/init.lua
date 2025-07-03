vim.o.path = vim.o.path .. '**'

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
