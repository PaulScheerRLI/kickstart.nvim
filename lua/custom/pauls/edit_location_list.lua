vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("insert_leave_location", { clear = true }),
  callback = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local loc = vim.fn.getloclist(0)

    -- Remove the existing entry for this buffer.
    -- This way the location list is a set
    -- navigating backwards from the top always gives you the
    -- most recent edit location
    for i = #loc, 1, -1 do
      if loc[i].bufnr == bufnr then
        table.remove(loc, i)
        break
      end
    end

    -- Append the current position
    table.insert(loc, {
      bufnr = bufnr,
      filename = filename,
      lnum = row,
      col = col + 1,
    })

    -- Update the location list Winid = 0 means current window
    vim.fn.setloclist(0, loc, "r")
    -- update the current index. $ means end of the list
    vim.fn.setloclist(0, {}, "r", { idx = "$" })
  end,
})
