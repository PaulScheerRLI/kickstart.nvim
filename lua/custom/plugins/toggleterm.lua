local history = {}

local function run_command(cmd)
  -- Add to history (deduplicate, most recent first)
  history = vim.tbl_filter(function(v)
    return v ~= cmd
  end, history)
  table.insert(history, 1, cmd)
  full_command = 'TermExec ' .. cmd
  vim.fn.histadd('cmd', full_command)
  vim.cmd(full_command)
end

local function pick_and_run()
  -- "New command..." as first entry, then history
  local items = vim.list_extend({ '» New command...' }, history)

  vim.ui.select(items, {
    prompt = 'TermExec:',
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if not choice then
      return
    end

    if choice == '» New command...' then
      vim.ui.input({ prompt = 'TermExec: ' }, function(input)
        if input and input ~= '' then
          run_command(input)
        end
      end)
    else
      run_command(choice)
    end
  end)
end

vim.keymap.set('n', '<leader>T', ':ToggleTerm<CR>')
return { 'akinsho/toggleterm.nvim', version = '*', config = { direction = 'vertical', size = vim.o.columns * 0.4 } }
