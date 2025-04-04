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
return {
  harpoon,
  { 'tpope/vim-fugitive' },
  { 'echasnovski/mini.surround' },
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
  {
    'mhartington/formatter.nvim',
    config = function()
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd
      augroup('__formatter__', { clear = true })
      autocmd('BufWritePost', {
        group = '__formatter__',
        command = ':FormatWrite',
      })
      -- Utilities for creating configurations
      local util = require 'formatter.util'
      -- Function to check if a file exists
      local function file_exists(path)
        local f = io.open(path, 'r')
        if f then
          f:close()
          return true
        else
          return false
        end
      end
      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      require('formatter').setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- All formatter configurations are opt-in
        filetype = {
          python = {
            function()
              local config_file = 'pyproject.toml'
              local args = {
                '-q',
                '--stdin-filename',
                util.escape_path(util.get_current_buffer_file_name()),
                '-',
              }
              if file_exists(config_file) then
                table.insert(args, '--config')
                table.insert(args, config_file)
              else
                vim.notify('Warning: Config file ' .. config_file .. ' not found. Using default Black settings.', vim.log.levels.WARN)
              end
              return {
                exe = 'black',
                args = args,
                stdin = true,
              }
            end,
          },
          -- Formatter configurations for filetype "lua" go here
          -- and will be executed in order
          lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require('formatter.filetypes.lua').stylua,
            -- You can also define your own configuration
            function()
              -- Supports conditional formatting
              if util.get_current_buffer_file_name() == 'special.lua' then
                return nil
              end

              -- Full specification of configurations is down below and in Vim help
              -- files
              return {
                exe = 'stylua',
                args = {
                  '--search-parent-directories',
                  '--stdin-filepath',
                  util.escape_path(util.get_current_buffer_file_path()),
                  '--',
                  '-',
                },
                stdin = true,
              }
            end,
          },

          -- Use the special "*" filetype for defining formatter configurations on
          -- any filetype
          ['*'] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require('formatter.filetypes.any').remove_trailing_whitespace,
            -- Remove trailing whitespace without 'sed'
            -- require("formatter.filetypes.any").substitute_trailing_whitespace,
          },
        },
      }
    end,
  },
}
