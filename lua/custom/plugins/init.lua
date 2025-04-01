--   You can add your own plugins here or in other files in this directory!
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
    end)

    vim.keymap.set('n', '<C-h>', function()
      harpoon_ui.nav_file(1)
    end)
    vim.keymap.set('n', '<C-t>', function()
      harpoon_ui.nav_file(2)
    end)
    vim.keymap.set('n', '<C-n>', function()
      harpoon_ui.nav_file(3)
    end)
    vim.keymap.set('n', '<C-s>', function()
      harpoon_ui.nav_file(4)
    end)
  end,
}
return {
  harpoon,
}
