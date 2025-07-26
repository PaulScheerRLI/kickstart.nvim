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
function get_current_jumplist()
  local winnr = vim.api.nvim_get_current_win()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local jumplist = vim.fn.getjumplist(winnr, tabpage)
  local current_idx = (jumplist[2] or tablelength(jumplist)) + 1
  return jumplist, current_idx
end

function traverse_jumpfiles(forward)
  -- ternary workaaround
  local direction = forward and 1 or -1
  local winnr = vim.api.nvim_get_current_win()
  local jumplist, current_idx = get_current_jumplist()
  local current_buffer = vim.api.nvim_get_current_buf()
  local length = tablelength(jumplist[1])
  local lnum, col = vim.api.nvim_win_get_position(winnr)
  local num = 1
  -- loop at least once
  upper = math.max(length, 1)
  for _ = 0, upper do
    current_idx = current_idx + direction
    if current_idx < 1 or current_idx > length then
      return vim.print 'No more files'
    end
    if current_buffer == jumplist[1][current_idx].bufnr then
      num = num + 1
    else
      break
    end
  end

  local command = nil
  if direction == -1 then
    command = 'execute "normal! ' .. tostring(num) .. '\\<c-o>"'
  else
    command = 'execute "normal! ' .. tostring(num) .. '\\<c-i>"'
  end
  print(command)
  vim.cmd(command)
end

vim.api.nvim_create_user_command('TraverseJumpFile', function(opts)
  local forward = nil
  if tonumber(opts.args) > 0 then
    forward = true
  else
    forward = false
  end
  traverse_jumpfiles(forward)
end, { nargs = 1 })

vim.keymap.set('n', '[j', function()
  traverse_jumpfiles(false)
end, { desc = 'Go to the previous JumpFile ' })

vim.keymap.set('n', ']j', function()
  traverse_jumpfiles(true)
end, { desc = 'Go to the next JumpFile ' })

function jumplist_files_into_quickfix()
  local jumplist, current_idx = get_current_jumplist()
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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end
vim.api.nvim_create_user_command('ClearJumpsFromNonBuffers', clear_jumps_from_deleted_buffers, {})
vim.api.nvim_create_user_command('JumpFilesIntoQuickFix', jumplist_files_into_quickfix, {})
