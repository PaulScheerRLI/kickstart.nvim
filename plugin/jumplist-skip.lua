local auto_source_buffers = {}
function turn_on_auto_source()
  local bufnr = vim.api.nvim_get_current_buf()
  auto_source_buffers[bufnr] = true
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('AutoSource', { clear = true }),
    callback = function()
      if auto_source_buffers[vim.api.nvim_get_current_buf()] then
        vim.cmd 'source %'
      end
    end,
  })
end

vim.api.nvim_create_user_command('AutoSourceOn', turn_on_auto_source, {})
function jumplist_files_into_quickfix()
  local winnr = vim.api.nvim_get_current_win()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local jumplist = vim.fn.getjumplist(winnr, tabpage)
  -- local current_idx = jumplist[2]
  -- vim.print(winnr, tabpage, current_idx, jumplist)
  -- local current_buffer = jumplist[1][current_idx + 1].bufnr
  local unique_buffers = {}
  local unique_jumplist = {}
  for i, jump in pairs(jumplist[1]) do
    if unique_buffers[jump.bufnr] then
    -- do nothing
    else
      unique_buffers[jump.bufnr] = true
      table.insert(unique_jumplist, jump)
    end
  end

  vim.fn.setqflist(unique_jumplist, 'r')
end

-- For some reason i did not realize that this is the case already
--   nvim seems to delete all jumps to buffers, when a buffer is deleted
function clear_jumps_from_deleted_buffers()
  local winnr = vim.api.nvim_get_current_win()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local jumplist = vim.fn.getjumplist(winnr, tabpage)
  local buffers = vim.api.nvim_list_bufs()
  local open_buffers = {}
  -- set jump at the current location
  vim.cmd "normal! m'"
  for i, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
      open_buffers[buf] = true
    end
  end
  local pruned_jumplist = {}
  for i, jump in pairs(jumplist[1]) do
    if open_buffers[jump.bufnr] then
      table.insert(pruned_jumplist, jump)
    end
  end
  vim.cmd 'clearjumps'
  for i, jump in pairs(pruned_jumplist) do
    vim.api.nvim_win_set_buf(winnr, jump.bufnr)
    vim.api.nvim_win_set_cursor(winnr, { jump.lnum, jump.col })
    vim.cmd "normal! m'"
  end
end

vim.api.nvim_create_user_command('ClearJumpsFromNonBuffers', clear_jumps_from_deleted_buffers, {})
vim.api.nvim_create_user_command('JumpFilesIntoQuickFix', jumplist_files_into_quickfix, {})
