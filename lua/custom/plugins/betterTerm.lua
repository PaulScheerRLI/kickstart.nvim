-- use slime instead
-- function get_selection_or_line()
--   local mode = vim.fn.mode()
--   vim.print(mode)
--   if mode == 'v' or mode == 'x' or mode == 'V' then
--     local pos_start = vim.fn.getpos "'<"
--     local lines = vim.fn.getregion(vim.fn.getpos '.', vim.fn.getpos 'v')
--     return table.concat(lines, '\n')
--   -- elseif mode == 'V' then
--   --   local pos_end = vim.fn.getpos "'>"
--   --
--   --   local start_line = pos_start[2]
--   --   local end_line = pos_end[2]
--   --
--   --   if start_line > end_line then
--   --     start_line, end_line = end_line, start_line
--   --   end
--   --
--   --   local lines = vim.fn.getline(start_line, end_line)
--   --   return table.concat(lines, '\n')
--   else
--     vim.print 'single line'
--     -- No visual selection: fallback to current line
--     return vim.fn.getline '.'
--   end
-- end
lastTerm = nil
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    if ft == 'better_term' then
      local bufname = vim.api.nvim_buf_get_name(0)
      local termname = vim.fn.fnamemodify(bufname, ':t') -- get basename
      lastTerm = termname
    end
  end,
})
return {
  'CRAG666/betterTerm.nvim',
  event = 'VimEnter',
  keys = {
    {
      mode = { 'n' },
      '<leader>to',
      function()
        local ok, word = pcall(vim.fn.input, 'Create terminal: ')
        if not ok then
          return
        end
        if word == '' then
          require('betterTerm').open()
          return
        end
        require('betterTerm').open(word)
      end,
      desc = 'Open BetterTerm 0',
    },
    {
      mode = { 'n', 't' },
      "<A-'>",
      function()
        if lastTerm == nil then
          require('betterTerm').open()
          return
        end
        require('betterTerm').open(lastTerm)
      end,
      desc = 'Switch betterTerm / go to last active terminal',
    },
    {
      mode = { 'n' },
      '<leader>tt',
      function()
        require('betterTerm').select()
      end,
      desc = 'Select terminal',
    },
  },
  opts = {
    position = 'bot',
    startInserted = false,
    new_tab_mapping = '<A-t>', -- Create new terminal
    size = 20,
    jump_tab_mapping = '<A-$tab>', -- Alt-0, Alt-1 etc,
  },
}
