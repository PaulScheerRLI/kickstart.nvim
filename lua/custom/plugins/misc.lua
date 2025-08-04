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
    'echasnovski/mini.move',
    config = function()
      require('mini.move').setup()
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
  {
    dir = vim.fn.stdpath 'config' .. '/comfy-line-numbers.nvim',
    enabled = true,

    config = function()
      require('comfy-line-numbers').setup {
        -- labels = {
        --   '1', '2', '3', '4', '5', '11', '12', '13', '14', '15', '21', '22', '23',
        --   '24', '25', '31', '32', '33', '34', '35', '41', '42', '43', '44', '45',
        --   '51', '52', '53', '54', '55', '111', '112', '113', '114', '115', '121',
        --   '122', '123', '124', '125', '131', '132', '133', '134', '135', '141',
        --   '142', '143', '144', '145', '151', '152', '153', '154', '155', '211',
        --   '212', '213', '214', '215', '221', '222', '223', '224', '225', '231',
        --   '232', '233', '234', '235', '241', '242', '243', '244', '245', '251',
        --   '252', '253', '254', '255',
        -- },
        -- up_key = 'j',
        -- down_key = 'k',

        -- Line numbers will be completely hidden for the following file/buffer types
        hidden_file_types = { 'undotree' },
        hidden_buffer_types = { 'terminal' },
      }

      -- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s│%T"
    end,
  },
  {
    'juk3-min/dejavu.nvim',
    dependencies = { 'j-hui/fidget.nvim' },
    config = function()
      require('dejavu').setup {
        notify = require('fidget').notification.notify,
        enabled = true,
        macro_key = 'y',
      }
    end,
  },
  {
    'NStefan002/screenkey.nvim',
    lazy = false,
    version = '*', -- or branch = "main", to use the latest commit
  },
}
