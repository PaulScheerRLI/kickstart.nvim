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
local ufo_fold = {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider needs a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local lspconfig = require 'lspconfig'
      local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        lspconfig[ls].setup {
          capabilities = capabilities,
        }
      end
    end,
  },
}
return {
  harpoon,
  ufo_fold,
}
