--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--  <ESC><ESC> does not work with tmux. instead we us C-B. In tmux thats <C-B><C-B> since the the first one
--  is escaped
vim.keymap.set('t', '<C-B>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<ESC><ESC>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-W><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-W><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-W><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
      win = { height = { min = 4, max = 15 } },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = '^1.0.0',
      },
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension 'live_grep_args')
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [b]uffer' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sF', function()
        builtin.find_files { no_ignore = true, hidden = true, no_ignore_parent = true }
      end, { desc = '[S]earch All [F]iles no ignore' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sG', builtin.git_status, { desc = '[S]earch [G]it status' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("."cfor repeat)' })
      vim.keymap.set('n', '<leader>scf', function()
        builtin.find_files { search_dirs = { vim.fn.expand '%:h:p' } }
      end, { desc = 'find in current directory' })
      vim.keymap.set('n', '<leader>scg', function()
        builtin.live_grep { search_dirs = { vim.fn.expand '%:h:p' } }
      end, { desc = 'Grep in current directory' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
      vim.keymap.set('n', '<leader>fg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      {
        -- does it hurt disabling it?
        'SmiteshP/nvim-navbuddy',
        enabled = false,
        dependencies = {
          'SmiteshP/nvim-navic',
          'MunifTanjim/nui.nvim',
          'numToStr/Comment.nvim', --  " Optional
        },
        config = function()
          local navbuddy = require 'nvim-navbuddy'
          local actions = require 'nvim-navbuddy.actions'

          vim.keymap.set('n', 'grN', navbuddy.open, { desc = '[G]oto [N]avbuddy window' })
          navbuddy.setup {
            window = {
              border = 'single', -- "rounded", "double", "solid", "none"
              -- or an array with eight chars building up the border in a clockwise fashion
              -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
              size = '60%', -- Or table format example: { height = "40%", width = "100%"}
              position = '50%', -- Or table format example: { row = "100%", col = "0%"}
              scrolloff = nil, -- scrolloff value within navbuddy window
              sections = {
                left = {
                  size = '20%',
                  border = nil, -- You can set border style for each section individually as well.
                },
                mid = {
                  size = '40%',
                  border = nil,
                },
                right = {
                  -- No size option for right most section. It fills to
                  -- remaining area.
                  border = nil,
                  preview = 'leaf', -- Right section can show previews too.
                  -- Options: "leaf", "always" or "never"
                },
              },
            },
            node_markers = {
              enabled = true,
              icons = {
                leaf = '  ',
                leaf_selected = ' → ',
                branch = ' ',
              },
            },
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
              String = ' ',
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
            use_default_mappings = true, -- If set to false, only mappings set
            -- by user are set. Else default
            -- mappings are used for keys
            -- that are not set by user
            mappings = {
              ['<esc>'] = actions.close(), -- Close and cursor to original location
              ['q'] = actions.close(),

              ['j'] = actions.next_sibling(), -- down
              ['k'] = actions.previous_sibling(), -- up

              ['h'] = actions.parent(), -- Move to left panel
              ['l'] = actions.children(), -- Move to right panel
              ['0'] = actions.root(), -- Move to first panel

              ['v'] = actions.visual_name(), -- Visual selection of name
              ['V'] = actions.visual_scope(), -- Visual selection of scope

              ['y'] = actions.yank_name(), -- Yank the name to system clipboard "+
              ['Y'] = actions.yank_scope(), -- Yank the scope to system clipboard "+

              ['i'] = actions.insert_name(), -- Insert at start of name
              ['I'] = actions.insert_scope(), -- Insert at start of scope

              ['a'] = actions.append_name(), -- Insert at end of name
              ['A'] = actions.append_scope(), -- Insert at end of scope

              ['r'] = actions.rename(), -- Rename currently focused symbol

              ['d'] = actions.delete(), -- Delete scope

              ['f'] = actions.fold_create(), -- Create fold of current scope
              ['F'] = actions.fold_delete(), -- Delete fold of current scope

              ['c'] = actions.comment(), -- Comment out current scope

              ['<enter>'] = actions.select(), -- Goto selected symbol
              ['o'] = actions.select(),

              ['J'] = actions.move_down(), -- Move focused node down
              ['K'] = actions.move_up(), -- Move focused node up

              ['s'] = actions.toggle_preview(), -- Show preview of current node

              ['<C-v>'] = actions.vsplit(), -- Open selected node in a vertical split
              ['<C-s>'] = actions.hsplit(), -- Open selected node in a horizontal split

              ['t'] = actions.telescope { -- Fuzzy finder at current level.
                layout_config = { -- All options that can be
                  height = 0.60, -- passed to telescope.nvim's
                  width = 0.60, -- default can be passed here.
                  prompt_position = 'top',
                  preview_width = 0.50,
                },
                layout_strategy = 'horizontal',
              },

              ['g?'] = actions.help(), -- Open mappings help window
            },
            lsp = {
              auto_attach = true, -- If set to true, you don't need to manually use attach function
              preference = nil, -- list of lsp server names in order of preference
            },
            source_buffer = {
              follow_node = true, -- Keep the current node in focus on the source buffer
              highlight = true, -- Highlight the currently focused node
              reorient = 'smart', -- "smart", "top", "mid" or "none"
              scrolloff = nil, -- scrolloff value when navbuddy is open
            },
            custom_hl_group = nil, -- "Visual" or any other hl group to use instead of inverted colors
          }
        end,
      },
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', event = 'VeryLazy', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        -- these options are applied
        opts = {
          ensure_installed = { 'lua_ls' },
          automatic_enable = {
            exclude = { 'pyrefly', 'ty' },
          },
        },
        dependencies = {
          { 'mason-org/mason.nvim', opts = {} },
          'neovim/nvim-lspconfig',
        },
      },

      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        -- virtual_text = {
        --   source = 'if_many',
        --   spacing = 2,
        --   format = function(diagnostic)
        --     local diagnostic_message = {
        --       [vim.diagnostic.severity.ERROR] = diagnostic.message,
        --       [vim.diagnostic.severity.WARN] = diagnostic.message,
        --       [vim.diagnostic.severity.INFO] = diagnostic.message,
        --       [vim.diagnostic.severity.HINT] = diagnostic.message,
        --     }
        --     return diagnostic_message[diagnostic.severity]
        --   end,
        -- },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'isort',
        'black',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- this does nothing it seems
      -- require('mason-lspconfig').setup {
      --   ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      --   automatic_enable = {
      --     exclude = { 'pyright', 'ty' },
      --   },
      --   automatic_installation = false,
      --   handlers = {
      --     function(server_name)
      --       local server = servers[server_name] or {}
      --       vim.print 'never called'
      --       -- This handles overriding only values explicitly passed
      --       -- by the server configuration above. Useful when disabling
      --       -- certain features of an LSP (for example, turning off formatting for ts_ls)
      --       server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      --       require('lspconfig')[server_name].setup { server }
      --     end,
      --   },
      -- }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notifiy_no_formatter = true,
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, htmldjango = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 5000,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters = {
        black = {
          prepend_args = { '--fast' },
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = {
          --'isort',
          'black',
        },
        htmldjango = { 'djlint' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VeryLazy',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        event = 'VeryLazy',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          --    See the README about individual language/framework/plugin snippets:
          -- `friendly-snippets` contains a variety of premade snippets.
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            event = 'VeryLazy',
            config = function()
              -- require('luasnip.loaders.from_vscode').load {}
              require('luasnip.loaders.from_vscode').lazy_load {}
              require('luasnip.loaders.from_vscode').lazy_load {
                paths = { vim.fn.stdpath 'config' .. '/snippets' },
              }
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      cmdline = {
        -- use 'inherit' to inherit mappings from top level `keymap` config
        keymap = { preset = 'cmdline' },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          -- Commands
          if type == ':' or type == '@' then
            return { 'cmdline' }
          end
          return {}
        end,
        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {},
          },
          list = {
            selection = {
              -- When `true`, will automatically select the first item in the completion list
              preselect = true,
              -- When `true`, inserts the completion item automatically when selecting it
              auto_insert = true,
            },
          },
          -- Whether to automatically show the window when new completion items are available
          menu = { auto_show = false },
          -- Displays a preview of the selected item on the current line
          ghost_text = { enabled = true },
        },
      },
      sources = {
        -- Removed buffer for now
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 0 },
          lsp = { score_offset = 1 },
          buffer = { score_offset = 0 },
          cmdline = {

            -- ignores cmdline completions when executing shell commands
            enabled = function()
              return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match "^[%%0-9,'<>%-]*!"
            end,
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = {
        sorts = {
          'score', -- Primary sort: by fuzzy matching score
          'sort_text', -- Secondary sort: by sortText field if scores are equal
          'label', -- Tertiary sort: by label if still tied
        },
        implementation = (function()
          if vim.fn.has 'wsl' == 1 then
            vim.print 'using rust'
            return 'rust'
          end
          -- vim.print 'using lua for blink'
          return 'lua'
        end)(),
      },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VeryLazy', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- Commented out since lua line is used right now
      --
      -- set use_icons to true if you have a Nerd Font
      --      statusline.setup {
      --        use_icons = vim.g.have_nerd_font,
      --        -- Content of statusline as functions which return statusline string. See
      --        -- `:h statusline` and code of default contents (used instead of `nil`).
      --        content = {
      --          -- Content for active window
      --          active = function()
      --            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      --            local git = MiniStatusline.section_git { trunc_width = 40 }
      --            local diff = MiniStatusline.section_diff { trunc_width = 75 }
      --            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      --            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
      --            local filename = MiniStatusline.section_filename { trunc_width = 140 }
      --            local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      --            local location = MiniStatusline.section_location { trunc_width = 75 }
      --            local search = MiniStatusline.section_searchcount { trunc_width = 75 }
      --
      --            return MiniStatusline.combine_groups {
      --              { hl = mode_hl, strings = { mode } },
      --              { hl = 'MiniStatuslineFilename', strings = { filename } },
      --              { hl = 'MiniStatuslineDevinfo', strings = { git } },
      --              '%<', -- Mark general truncate point
      --              { hl = 'MiniStatuslineDevinfo', strings = { diff, diagnostics, lsp } },
      --              '%=', -- End left alignment
      --              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
      --              { hl = mode_hl, strings = { search, location } },
      --            }
      --          end,
      --          -- Content for inactive window(s)
      --          inactive = nil,
      --        },
      --
      --        -- Whether to use icons by default
      --        use_icons = true,
      --      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = 'v',
          node_decremental = 'V',
        },
      },
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  -- -- require 'kickstart.plugins.neo-tree',
  --
  -- indent_line seems to make neovim a little slow for me
  -- i tried out indentmini but it was even worse
  -- require 'kickstart.plugins.indent_line',
  -- autopairs feel like they are rarely useful
  -- require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  --
  require 'custom.plugins.betterTerm',

  -- what can code-runner do that slime cant?
  -- require 'custom.plugins.code-runner',
  require 'custom.plugins.mason_setup',
  require 'custom.plugins.lspconfigs',
  require 'custom.plugins.fugitive',
  require 'custom.plugins.gF-python-traceback',
  require 'custom.plugins.harpoon',
  require 'custom.plugins.misc',
  require 'custom.plugins.lazygit',
  require 'custom.plugins.minisessions',
  require 'custom.plugins.nvim-scissors',
  require 'custom.plugins.otter',
  require 'custom.plugins.refactor',
  require 'custom.plugins.render-markdown',
  require 'custom.plugins.slides',
  require 'custom.plugins.tmux',
  require 'custom.plugins.treesitter-context',
  require 'custom.plugins.treesitter-textobjects',
  require 'custom.plugins.vim_slime',
  require 'custom.plugins.vimbegood',
  require 'custom.plugins.zettelkasten',

  require 'custom.plugins.flutter-nvim',
  require 'custom.plugins.matchup',
  require 'custom.plugins.undotree',
  require 'custom.plugins.lualine',
  --
  -- { import = 'custom.plugins.' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

require 'custom'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- local lspconfig = require 'lspconfig'
-- local configs = require 'lspconfig.configs'
-- --local root_files = {
-- --  'pyproject.toml',
-- --  'setup.py',
-- --  'setup.cfg',
-- --  'requirements.txt',
-- --  'Pipfile',
-- --  '.git',
-- --}
-- --
-- if not configs.lemminx then
--   configs.lemminx = {
-- lspconfig.dartls.setup {
--   settings = {
--     color = { -- show the derived colours for dart variables
--       enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
--       background = true, -- highlight the background
--       background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
--       foreground = true, -- highlight the foreground
--       virtual_text = true, -- show the highlight using virtual text
--       virtual_text_str = '■', -- the virtual text character to highlight
--     },
--   },
-- }

--local configs = require 'lspconfig.configs'
--local root_files = {
--  'pyproject.toml',
--  'setup.py',
--  'setup.cfg',
--  'requirements.txt',
--  'Pipfile',
--  '.git',
--}
--
--     maxItemsComputed = 5103,
--     settings = {
--       xml = {
--         symbols = { maxItemsComputed = 5002 },
--         maxItemsComputed = 5003,
--       },
--       railml = {
--         symbols = { maxItemsComputed = 5002 },
--         maxItemsComputed = 5003,
--       },
--
--       symbols = { maxItemsComputed = 5002 },
--       maxItemsComputed = 5103,
--     },
--     default_config = {
--
--       maxItemsComputed = 5103,
--       settings = {
--         xml = {
--           symbols = { maxItemsComputed = 5002 },
--           maxItemsComputed = 5003,
--         },
--         railml = {
--           symbols = { maxItemsComputed = 5002 },
--           maxItemsComputed = 5003,
--         },
--
--         symbols = { maxItemsComputed = 5002 },
--         maxItemsComputed = 5103,
--       },
--     },
--   }
-- end
-- lspconfig.lemminx.setup {}
-- function lemminx()
--   vim.lsp.config('lemminx', {
--     -- Server-specific settings. See `:help lsp-quickstart`
--     settings = {
--       ['lemminx'] = {
--         xml = {
--           symbols = { maxItemsComputed = 10009 },
--         },
--         settings = {
--
--           xml = {
--             symbols = { maxItemsComputed = 10008 },
--           },
--         },
--       },
--     },
--   })
-- end
-- lemminx()
