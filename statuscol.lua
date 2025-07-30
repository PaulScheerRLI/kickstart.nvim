vim.opt.numberwidth = 1
vim.o.relativenumber = true
vim.opt.signcolumn = 'number'
local statuscolumn = {}

myStatuscolumn = function()
  -- We will store the output in a variable so that we can call multiple functions inside here and add their value to the statuscolumn
  local tokyonight = require 'lualine.themes.tokyonight' -- Change the background of inactive lualine/statusline to slightly darker
  vim.api.nvim_set_hl(0, 'StatusBorder', {
    -- Check the `nvim_set_hl()` help file to see all the available options
    bg = tokyonight.inactive.c.bg,
  })
  local text = ''
  if vim.v.relnum ~= 0 then
    text = '%#StatusBorder#%s%=%T%@NumCb@%l│%T'
    return text
  end
  -- This is just a different way of doing
  --
  -- text = text .. statuscolumn.brorder
  --
  -- This will make a lot more sense as we add more things
  text = table.concat {
    text,
    '%s%=',
    statuscolumn.number { type = 'hybird' },
    statuscolumn.border(),

    '%',
  }

  return text
end
-- With this line we will be able to use myStatuscolumn by requiring this file and calling the function
statuscolumn.border = function()
  -- See how the characters is larger then the rest? That's how we make the border look like a single line
  return '%#StatusBorder#│'
end
statuscolumn.number = function(config)
  if config.type == 'normal' then
    return vim.v.lnum
  elseif config.type == 'relative' then
    return vim.v.relnum
  else
    -- If the relative number for a line is 0 then we know the cursor is on that line. So, we will show it's line number instead of the relative line number
    if vim.v.virtnum ~= 0 then
      return ''
    end
    return (vim.v.relnum == 0 and (vim.v.lnum < 10 and vim.v.lnum .. '  ' or vim.v.lnum) or (vim.v.relnum < 10 and vim.v.relnum .. ' ' or vim.v.relnum))
    -- return vim.v.relnum == 0 and vim.v.lnum or vim.v.relnum
  end
end

vim.opt.statuscolumn = "%s%=%#StatusBorder#%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%="
vim.o.statuscolumn = '%!v:lua.myStatuscolumn()'
-- The 0 is the namespace which is the default namespace
-- MyHighlight is the group name

-- fg, bg are foreground & background

-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
-- asdfkj
