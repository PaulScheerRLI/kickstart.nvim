local lspconfig = require 'lspconfig'
local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('lemminx', {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Your on_attach logic here (keymaps, etc.)
  end,
  settings = {
    -- Your Lemminx settings go here

    xml = {
      symbols = { maxItemsComputed = 20008 },
    },
  },
})
return {}
