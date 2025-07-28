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
}
