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
      require('lualine').setup {
        sections = {
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
        },
        -- OR in winbar
        winbar = {
          lualine_c = {
            'navic',
            color_correction = nil,
            navic_opts = nil,
          },
        },
      }
    end,
  },
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
