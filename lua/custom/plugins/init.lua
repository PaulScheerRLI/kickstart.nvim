--   You can add your own plugins here or in other files in this directory!
--   z
--  I promise not to create any merge conflicts in this directory .)
--
-- See the kickstart.nvim README for more information
local harpoon = {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',

  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end)
    vim.keymap.set('n', '<C-s>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    -- destroys fast move between windows
    -- vim.keymap.set('n', '<C-h>', function()
    -- harpoon:list():select(1)
    -- end)
    vim.keymap.set('n', '<C-t>', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():select(3)
    end)
    --vim.keymap.set('n', '<C-s>', function()
    --  harpoon:list():select(4)
    --end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end)
    --
    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<C-e>', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })
  end,
}
return {
  harpoon,
  { 'tpope/vim-fugitive' },
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
        autoread = false,

        -- Whether to write currently read session before quitting Neovim
        autowrite = false,

        -- Directory where global sessions are stored (use `''` to disable)
        -- directory = `''`, --<"session" subdir of user data directory from |stdpath()|>,

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
        verbose = { read = false, write = true, delete = true },
      }
    end,

    --[[
    -- Commands for Sessions
    --  :lua MiniSessions.write("My-Foo-Session")
    --  :lua MiniSessions.read("My-Foo-Session")
    --]]
  },
}
