return {
  { 'kkoomen/vim-doge' },
  {
    'echasnovski/mini.surround',
    -- add = 'sa', -- Add surrounding in Normal and Visual modes
    --  delete = 'sd', -- Delete surrounding
    --  find = 'sf', -- Find surrounding (to the right)
    --  find_left = 'sF', -- Find surrounding (to the left)
    --  highlight = 'sh', -- Highlight surrounding
    --  replace = 'sr', -- Replace surrounding
    --  update_n_lines = 'sn', -- Update `n_lines`
    --
  },
  { 'ojroques/nvim-bufdel' },
  {
    'hat0uma/csvview.nvim',
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  },
  {
    'okuuva/auto-save.nvim',
    version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    cmd = 'ASToggle', -- optional for lazy loading on command
    event = {}, -- optional for lazy loading on trigger events
    opts = {
      enabled = false,
      trigger_events = { -- See :h events
        immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' }, -- vim events that trigger an immediate save
        defer_save = { 'InsertLeave', 'TextChanged', 'TextChangedP', 'TextChangedI' }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = { 'InsertEnter' }, -- vim events that cancel a pending deferred save
        condition = function(buf)
          local excluded_filetypes = {
            -- this one is especially useful if you use neovim as a commit message editor
            'gitcommit',
            -- most of these are usually set to non-modifiable, which prevents autosaving
            -- by default, but it doesn't hurt to be extra safe.
            'NvimTree',
            'Outline',
            'TelescopePrompt',
            'alpha',
            'dashboard',
            'lazygit',
            'neo-tree',
            'oil',
            'prompt',
            'toggleterm',
          }
          if vim.tbl_contains(excluded_filetypes, vim.fn.getbufvar(buf, '&filetype')) then
            return false
          end
          return true
        end,
      },
      noautocmd = true,
      debounce_delay = 50, -- delay after which a pending save is executed
      -- your config goes here
      -- or just leave it empty :)
    },
  },
  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    config = function()
      require('telescope').load_extension 'smart_open'
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      -- Only required if using match_algorithm fzf
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    },
  },

  --  {
  -- 'danilamihailov/beacon.nvim',
  -- config = function()
  --   require('beacon').setup ({
  --     cursor_events = {}
  --   })
  --   vim.keymap.set('n', '<leader>jj', require('beacon').highlight_cursor, { desc = 'Beacon and highlight the cursor' })
  -- end,
  -- }, -- lazy calls etup() by itself
  {
    'echasnovski/mini.move',
    config = function()
      require('mini.move').setup {
        winborder = 'none',
      }
    end,
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
  -- {
  --   dir = vim.fn.stdpath 'config' .. '/comfy-line-numbers.nvim',
  --   enabled = true,
  --
  --   config = function()
  --     require('comfy-line-numbers').setup {
  --       -- labels = {
  --       --   '1', '2', '3', '4', '5', '11', '12', '13', '14', '15', '21', '22', '23',
  --       --   '24', '25', '31', '32', '33', '34', '35', '41', '42', '43', '44', '45',
  --       --   '51', '52', '53', '54', '55', '111', '112', '113', '114', '115', '121',
  --       --   '122', '123', '124', '125', '131', '132', '133', '134', '135', '141',
  --       --   '142', '143', '144', '145', '151', '152', '153', '154', '155', '211',
  --       --   '212', '213', '214', '215', '221', '222', '223', '224', '225', '231',
  --       --   '232', '233', '234', '235', '241', '242', '243', '244', '245', '251',
  --       --   '252', '253', '254', '255',
  --       -- },
  --       -- up_key = 'j',
  --       -- down_key = 'k',
  --
  --       -- Line numbers will be completely hidden for the following file/buffer types
  --       hidden_file_types = { 'undotree' },
  --       hidden_buffer_types = { 'terminal' },
  --     }
  --
  --     -- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s│%T"
  --   end,
  -- },
  {
    'nat-418/boole.nvim',
    config = function()
      require('boole').setup {
        mappings = {
          increment = '<C-a>',
          decrement = '<C-x>',
        },
        -- User defined loops
        additions = {
          { 'true', 'false' },
          { 'True', 'False' },
          { 'TRUE', 'FALSE' },
          -- { 'tic', 'tac', 'toe' },
        },
        allow_caps_additions = {
          { 'enable', 'disable' },
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
        },
      }
    end,
  },
  {
    'juk3-min/dejavu.nvim',
    opts = {
      callback = function(x)
        vim.print(x)
        print 'foo'
      end,
    },
    dependencies = { 'j-hui/fidget.nvim' },
    config = function()
      require('dejavu').setup {
        notify = function(x)
          require('fidget').notification.notify('', vim.log.levels.INFO, { annote = x })
        end,
        enabled = true,
      }
    end,
  },
  {
    'NStefan002/screenkey.nvim',
    lazy = false,
    version = '*', -- or branch = "main", to use the latest commit
  },
  {
    -- This plugin depends on on of these two LSP servers to configured
    --   https://github.com/valentjn/ltex-ls
    --   https://github.com/ltex-plus/ltex-ls-plus
    'barreiroleo/ltex_extra.nvim',
    -- dependencies = { 'neovim/nvim-lspconfig' },

    opts = {
      -- load_langs = { 'en-US', 'de-DE' },
      load_langs = { 'de-DE' },
      -- save to .ltex dir
      path = '.ltex',
    },

    config = function(_, opts)
      -- Ltex LSP
      vim.lsp.config('ltex_plus', {
        on_attach = function()
          require('ltex_extra').setup(opts)
        end,

        settings = {
          ltex = {
            checkFrequency = 'save',
            -- enabled = { 'markdown', 'plaintex', 'rst', 'tex', 'latex' },
            language = 'de-DE', -- default language
          },
          ltex_plus = {
            checkFrequency = 'save',
            -- enabled = { 'markdown', 'plaintex', 'rst', 'tex', 'latex' },
            language = 'de-DE', -- default language
          },
        },
      })
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = { default_file_explorer = false },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    'beeender/richclip.nvim',
    config = function()
      require('richclip').setup {
        --- Specify the richclip executable path. If it is nil, the plugin
        --- will try to download it to 'plugin_dir/bin' automatically.
        --- The plugin tries to search for the executable in:
        --- 'richclip_path' if it is set, '$PATH', 'plugin_dir/bin'.
        richclip_path = '/usr/local/richclip',
        --- Set g:clipboard to let richclip take over the clipboard.
        set_g_clipboard = true,
        --- To print debug logs
        enable_debug = false,
      }
    end,
  },
  {
    -- for gbrwosing github
    'tpope/vim-rhubarb',
  },
  {
    'msaher/bufix.nvim',
    config = {
      want_buffer_keymaps = true,
    },
    -- calling setup is optional :)
  },
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ 'n', 'x' }, '<up>', function()
        mc.lineAddCursor(-1)
      end)
      set({ 'n', 'x' }, '<down>', function()
        mc.lineAddCursor(1)
      end)
      set({ 'n', 'x' }, '<leader><up>', function()
        mc.lineSkipCursor(-1)
      end)
      set({ 'n', 'x' }, '<leader><down>', function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ 'n', 'x' }, '<leader>n', function()
        mc.matchAddCursor(1)
      end)
      set({ 'n', 'x' }, '<leader>s', function()
        mc.matchSkipCursor(1)
      end)
      set({ 'n', 'x' }, '<leader>N', function()
        mc.matchAddCursor(-1)
      end)
      set({ 'n', 'x' }, '<leader>S', function()
        mc.matchSkipCursor(-1)
      end)

      -- Add and remove cursors with control + left click.
      set('n', '<c-leftmouse>', mc.handleMouse)
      set('n', '<c-leftdrag>', mc.handleMouseDrag)
      set('n', '<c-leftrelease>', mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ 'n', 'x' }, 'c-q', mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
        layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet('n', '<esc>', function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { reverse = true })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
      hl(0, 'MultiCursorDisabledCursor', { reverse = true })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
    end,
  },
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}
