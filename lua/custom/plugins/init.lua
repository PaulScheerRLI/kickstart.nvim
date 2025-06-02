--   You can add your own plugins here or in other files in this directory!
--   z
--  I promise not to create any merge conflicts in this directory .)
--
-- See the kickstart.nvim README for more information
--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  local win_width = vim.fn.winwidth(0)
  return function(str)
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      local no_vowels = str:gsub('[aeiouAEIOU]', '')
      return no_vowels:sub(-trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end

return {
  {
    'b0o/incline.nvim',
    config = function()
      require('incline').setup()
    end,
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
  },
  { 'kkoomen/vim-doge' },
  --  {
  --    'SmiteshP/nvim-navbuddy',
  --    dependencies = {
  --      'neovim/nvim-lspconfig',
  --      'SmiteshP/nvim-navic',
  --      'MunifTanjim/nui.nvim',
  --      'numToStr/Comment.nvim', -- Optional
  --      'nvim-telescope/telescope.nvim', -- Optional
  --    },
  --},
  {
    'SmiteshP/nvim-navic',
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
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local function window()
        return vim.api.nvim_win_get_number(0)
      end
      require('lualine').setup {
        --sections = {
        --          lualine_c = {
        --            'navic',
        --
        --            -- Component specific options
        --            color_correction = nil, -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
        --            -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
        --            -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
        --            --	 be enough when the lualine section isn't changing colors based on the mode.
        --            -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
        --            --	 the current section.
        --
        --            navic_opts = nil, -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
        --          },
        --},
        -- OR in winbar
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { { 'branch', fmt = trunc(1920 / 2, 15, nil, true) }, 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = { window },
        },
        tabline = {},
        winbar = {
          lualine_c = {
            'navic',
            color_correction = nil,
            navic_opts = nil,
          },
          lualine_z = { 'lsp_status' },
        },
        inactive_winbar = {},
        extensions = {},
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
  {
    'echasnovski/mini.sessions',
    config = function()
      print ':lua MiniSessions.write/read("foo")'
      require('mini.sessions').setup {
        -- Whether to read default session if Neovim opened without file arguments
        autoread = true,

        autowrite = true,
        -- Whether to write currently read session before quitting Neovim

        -- Directory where global sessions are stored (use `''` to disable)
        directory = '',

        -- File for local session (use `''` to disable)
        file = 'Session.vim',

        -- Whether to force possibly harmful actions (meaning depends on function)
        force = { read = false, write = true, delete = false },

        -- Hook functions for actions. Default `nil` means 'do nothing'.
        hooks = {
          -- Before successful action
          pre = { read = nil, write = nil, delete = nil },
          -- After successful action
          post = { read = nil, write = nil, delete = nil },
        },

        -- Whether to print session path after action
        verbose = { read = true, write = true, delete = true },
      }
    end,

    --[[
    -- Commands for Sessions
    --  :lua MiniSessions.write("My-Foo-Session")
    --  :lua MiniSessions.read("My-Foo-Session")
    --]]
  },
}
