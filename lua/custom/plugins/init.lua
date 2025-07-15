return {
  { 'kkoomen/vim-doge' },
  {
    'SmiteshP/nvim-navic',
    event = 'VeryLazy',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      navic = require 'nvim-navic'
      navic.setup {
        icons = {
          File = '󰈙 ',
          Module = ' ',
          Namespace = '󰌗 ',
          Package = ' ',
          Class = '󰌗 ',
          Method = '󰆧 ',
          Property = ' ',
          Field = ' ',
          Constructor = ' ',
          Enum = '󰕘',
          Interface = '󰕘',
          Function = '󰊕 ',
          Variable = '󰆧 ',
          Constant = '󰏿 ',
          String = '󰀬 ',
          Number = '󰎠 ',
          Boolean = '◩ ',
          Array = '󰅪 ',
          Object = '󰅩 ',
          Key = '󰌋 ',
          Null = '󰟢 ',
          EnumMember = ' ',
          Struct = '󰌗 ',
          Event = ' ',
          Operator = '󰆕 ',
          TypeParameter = '󰊄 ',
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        highlight = false,
        separator = ' > ',
        depth_limit = 0,
        depth_limit_indicator = '..',
        safe_output = true,
        lazy_update_context = false,
        click = true,
        format_text = function(text)
          return text
        end,
      }
    end,
  },
  { 'echasnovski/mini.surround' },
  { 'ojroques/nvim-bufdel' },
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
}
