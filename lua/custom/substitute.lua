local selected_text = function()
  local mode = vim.api.nvim_get_mode().mode
  local opts = {}
  -- \22 is an escaped version of <c-v>
  if mode == 'v' or mode == 'V' or mode == '\22' then
    opts.type = mode
  end
  return vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', opts)
end

local function get_operator_text(type)
  local start_pos = vim.api.nvim_buf_get_mark(0, '[')
  local end_pos = vim.api.nvim_buf_get_mark(0, ']')

  local end_col = end_pos[2] + 1
  if type == 'line' then
    end_col = -1
  end

  local lines = vim.api.nvim_buf_get_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_col, {})

  local text = table.concat(lines, '\n')
  return text
end


-- Works for normal and x mode. amazing
vim.keymap.set({ 'x' ,'n'}, 'sr', function()
  vim.go.operatorfunc = function(type)
    local start_pos = vim.api.nvim_buf_get_mark(0, '[')
    local end_pos = vim.api.nvim_buf_get_mark(0, ']')

    local end_col = end_pos[2] + 1
    if type == 'line' then
      end_col = -1
    elseif type=="block" then
      error("Block mode not supported")
    end
    -- replace text
    vim.api.nvim_buf_set_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_col, vim.split(vim.fn.getreg '0', '\n'))
  end
  return 'g@'
end, { desc = "Substitute motion. Paste from 0 register to motion, deleting the 'selection' into void", expr = true })
