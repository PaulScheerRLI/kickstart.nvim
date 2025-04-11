--   You can add your own plugins here or in other files in this directory!
--   z
--  I promise not to create any merge conflicts in this directory .)
--
-- See the kickstart.nvim README for more information
local harpoon = {
  'ThePrimeagen/harpoon',
  config = function()
    local harpoon = require 'harpoon'
    local harpoon_ui = require 'harpoon.ui'

    harpoon.setup()

    vim.keymap.set('n', '<leader>a', function()
      require('harpoon.mark').add_file()
    end)

    vim.keymap.set('n', '<C-e>', function()
      harpoon_ui.toggle_quick_menu()
    end, { desc = 'Toogle quick menu in Harpoon' })

    vim.keymap.set('n', '<C-h>', function()
      harpoon_ui.nav_file(1)
    end, { desc = 'Go to file 1 in Harpoon' })

    vim.keymap.set('n', '<C-t>', function()
      harpoon_ui.nav_file(2)
    end, { desc = 'Go to file 2 in Harpoon' })

    vim.keymap.set('n', '<C-s>', function()
      harpoon_ui.nav_file(3)
    end, { desc = 'Go to file 3 in Harpoon' })

    vim.keymap.set('n', '<C-n>', function()
      harpoon_ui.nav_next()
    end, { desc = 'Go to next Harpoon File' })
  end,
}
require('lspconfig').django_lsp = {
  default_config = {
    cmd = { '.venv/Scripts/python.exe', 'J:/dev/python/django-manager-lsp/main.py' },
    filetypes = { 'python' },
    -- root_dir = require('lspconfig.util').root_pattern('manage.py', '.git'),
  },
}
return {
  harpoon,
  { 'tpope/vim-fugitive' },
  { 'echasnovski/mini.surround' },
  { 'echasnovski/mini.icons' },
  {
    'echasnovski/mini.move',
    config = require('mini.move').setup(),
    -- default mappings set by setup. Added as comment for documentation
    --[[
    mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = '<M-h>',
    right = '<M-l>',
    down = '<M-j>',
    up = '<M-k>',

    -- Move current line in Normal mode
    line_left = '<M-h>',
    line_right = '<M-l>',
    line_down = '<M-j>',
    line_up = '<M-k>',
    },
--]]
  },
  {
    'echasnovski/mini.sessions',
    config = function()
      print 'minis sessions'
      require('mini.sessions').setup()
    end,
  },
}
