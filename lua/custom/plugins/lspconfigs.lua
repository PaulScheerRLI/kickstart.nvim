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
  -- copied from pyright
  vim.lsp.config('basedpyright', {
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = false,
          typeCheckingMode = 'off',
          useLibraryCodeForTypes = false,
        },
      },
    },
  })
  vim.lsp.config('pyright', {
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = false,
          typeCheckingMode = 'off',
          useLibraryCodeForTypes = false,
        },
      },
    },
  })
  vim.lsp.config('harper_ls', {
    -- Like this??
    diagnosticSeverity = 'error',

    settings = {
      harper_ls = {
        linters = {
          SentenceCapitalization = false,
          SpellCheck = false,
        },
        diagnosticSeverity = 'error',
      },
    },
  })
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

local language_id_mapping = {
  bib = 'bibtex',
  plaintex = 'tex',
  rnoweb = 'rsweave',
  htmldjango = 'html',
  rst = 'restructuredtext',
  tex = 'latex',
  pandoc = 'markdown',
  text = 'plaintext',
}

local filetypes = {
  'bib',
  'gitcommit',
  'markdown',
  'org',
  'plaintex',
  'rst',
  'rnoweb',
  'tex',
  'pandoc',
  'quarto',
  'rmd',
  'context',
  'html',
  'htmldjango',
  'xhtml',
  'mail',
  'text',
}

local function get_language_id(_, filetype)
  local language_id = language_id_mapping[filetype]
  if language_id then
    return language_id
  else
    return filetype
  end
end
local enabled_ids = {}
do
  local enabled_keys = {}
  for _, ft in ipairs(filetypes) do
    local id = get_language_id({}, ft)
    if not enabled_keys[id] then
      enabled_keys[id] = true
      table.insert(enabled_ids, id)
    end
  end
end

-- Translate htmldjango to html
vim.lsp.config('superhtml', {
  get_language_id = get_language_id,
})
-- superhtml is eneabled through mason anyways but doing it does not hurt
vim.lsp.enable 'superhtml'

-- Used for better spellchecking
vim.lsp.config('ltex_plus', {
  cmd = { 'ltex-ls-plus' },
  filetypes = filetypes,
  root_markers = { '.git' },
  get_language_id = get_language_id,
  -- NOTE: it seems like the used settings are ltex and not ltex_plus. maybe because the underlying lsp is still the same?
  settings = {
    ltex_plus = {
      enabled = enabled_ids,

      checkFrequency = 'save',
      language = 'de-DE',
      sentenceCacheSize = 2000,
      additionalRules = {
        enablePickyRules = true,
        motherTongue = 'de-DE',
      },
    },
  },
})
-- disabled for now since it hogs memeory a little bit i think
-- vim.lsp.enable 'ltex_plus'
function CheckEnglish()
  local config = vim.lsp.config['ltex_plus']
  local new_config = vim.tbl_deep_extend('force', {}, config, { settings = { ltex_plus = { language = 'en' }, ltex = { language = 'en' } } })
  vim.lsp.start(new_config)
end

function CheckGerman()
  local config = vim.lsp.config['ltex_plus']
  local new_config = vim.tbl_deep_extend('force', {}, config, { settings = { ltex_plus = { language = 'de-DE' } } })
  vim.lsp.start(new_config)
end
return {}
