function get_selection_or_line()
  local mode = vim.fn.mode()
  vim.print(mode)
  if mode == 'v' or mode == 'x' or mode == 'V' then
    local pos_start = vim.fn.getpos "'<"
    local lines = vim.fn.getregion(vim.fn.getpos '.', vim.fn.getpos 'v')
    return table.concat(lines, '\n')
  -- elseif mode == 'V' then
  --   local pos_end = vim.fn.getpos "'>"
  --
  --   local start_line = pos_start[2]
  --   local end_line = pos_end[2]
  --
  --   if start_line > end_line then
  --     start_line, end_line = end_line, start_line
  --   end
  --
  --   local lines = vim.fn.getline(start_line, end_line)
  --   return table.concat(lines, '\n')
  else
    vim.print 'single line'
    -- No visual selection: fallback to current line
    return vim.fn.getline '.'
  end
end
return {
  'CRAG666/betterTerm.nvim',
  keys = {
    {
      mode = { 'n', 't' },
      '<leader>t0',
      function()
        require('betterTerm').open()
      end,
      desc = 'Open BetterTerm 0',
    },
    {
      mode = { 'n', 't' },
      '<leader>t0',
      function()
        require('betterTerm').open(1)
      end,
      desc = 'Open BetterTerm 1',
    },
    {
      '<leader>tt',
      function()
        require('betterTerm').select()
      end,
      desc = 'Select terminal',
    },

    {
      mode = { 'n', 'v', 'x' },
      '<leader>ts',
      function()
        local cmd = get_selection_or_line()
        require('betterTerm').send(cmd, 0, 'interrupt')
        -- Send an empty line to ensure final block is executed
        -- Use feedkeys with correct termcodes to exit terminal insert mode
        vim.cmd 'stopinsert' -- reliable alternative to <C-\><C-n>
        -- Wait a bit to ensure the mode switches before running window commands
        -- vim.defer_fn(function()
        --   vim.print 'waiting'
        -- end, 2000) -- delay in milliseconds
        -- vim.print 'centering'
        --
        -- vim.cmd 'wincmd p'
      end,
      desc = 'Send to terminal 0',
    },
  },
  opts = {
    position = 'bot',
    size = 20,
    jump_tab_mapping = '<A-$tab>',
  },
}
