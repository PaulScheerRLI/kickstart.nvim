vim.schedule(function()
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

  vim.lsp.config('pyrefly', {})
  vim.lsp.config('ty', {})
  vim.lsp.config('lua_ls', { settings = { lua = { loglevel = 'trace' } } })
  vim.lsp.config(
    'pyright',
    { settings = {
      python = {
        analysis = {
          autoSearchPaths = false,
          typeCheckingMode = 'off',
        },
      },
    } }
  )
  vim.lsp.enable 'pyright'
  -- vim.lsp.enable 'pyright'
  vim.lsp.config('efm', {
    capabilities = capabilities,
    filetypes = { '!**.py' },
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
  vim.lsp.enable('efm', false)
end)
return {}
