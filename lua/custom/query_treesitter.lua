print 'hello from query tree'

local ts = vim.treesitter
function getTSCaptures(query, bufnr)
  -- Temporarily open the buffer in a window. This is needed since injected languages are only detected when opening the file.
  -- kinda strange behvaioru
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd 'keepalt silent belowright split'
  local tmp_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(tmp_win, bufnr)

  local parser = ts.get_parser(bufnr)
  local trees = { parser:parse()[1] }
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local all_trees = {}

  -- Add main tree
  for _, tree in ipairs(parser:parse()) do
    table.insert(all_trees, { tree = tree, lang = parser:lang() })
  end

  -- Add injected trees manually
  local function addChildren(parser)
    for key, child in pairs(parser:children()) do
      for _, tree in pairs(child:parse()) do
        table.insert(all_trees, { tree = tree, lang = child:lang() })
      end
      addChildren(child)
    end
  end
  addChildren(parser)

  -- the children/ injected languages are detected. close window again
  vim.api.nvim_win_close(tmp_win, true)
  vim.api.nvim_set_current_win(cur_win)

  local found_nodes = {}
  for _, tree_data in ipairs(all_trees) do
    local tree = tree_data.tree
    local lang = tree_data.lang
    local root = tree:root()
    -- Query example: get all text and element nodes from any tree
    local ok, query = pcall(function()
      return ts.query.parse(lang, query)
    end)
    if ok then
      for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
        -- print 'found'
        -- local name = query.captures[id]
        -- local sr, sc, er, ec = node:range()
        table.insert(found_nodes, node)
      end
    else
      -- print 'not ok'
      -- print(lang)
      -- ts.query.parse(lang, query)
    end
  end
  return found_nodes, all_trees
end
function simple_query(capture, quicklist_method)
  -- use like 
  -- :QueryTSCaputre lhs -r
  -- Capture groups can be found inside the .scm files
  --/home/ubuntu/.local/share/nvim/lazy/nvim-treesitter-textobjects/queries/python/textobjects.scm

  assert(quicklist_method == 'r' or quicklist_method == 'a' or quicklist_method == 'f' or quicklist_method == ' ' or quicklist_method == nil)
  quicklist_method = quicklist_method or 'r'
  assert(string.sub(capture, 0, 1) ~= '@')

  if capture == nil or capture == '' then
    error 'Pass a query like [[@text]] to the function. quotes around query are optional.'
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  local query = vim.treesitter.query.get(lang, 'textobjects')
  if query == nil then
    print('empty query')
    return
    
  end
  local parser = vim.treesitter.get_parser(bufnr, lang)
  local tree = parser:parse()[1]
  local root = tree:root()
  qf_entries = {}
  for id, node, _ in query:iter_captures(root, bufnr) do
    local name = query.captures[id]
    if name == capture then
      local sr, sc, er, ec = node:range()
      local ok, text = pcall(ts.get_node_text, node, bufnr)
      table.insert(qf_entries, {
        bufnr = bufnr,
        lnum = sr + 1,
        end_lnum = er + 1,
        col = sc + 1,
        end_col = ec + 1,
        text = text,
      })
    end
  end
  vim.fn.setqflist(qf_entries, quicklist_method)
  print('successfully set quickfix with ' .. capture)
end

local function select_current_qf_item()
  local qf_list = vim.fn.getqflist()
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  local item = qf_list[idx]

  if not item or not item.bufnr or item.bufnr == 0 then
    return
  end

  local bufnr = item.bufnr
  local start_lnum = item.lnum
  local start_col = item.col
  local end_lnum = item.end_lnum or item.lnum
  local end_col = item.end_col - 1 or (item.col + 1)
  -- Switch to the buffer and move the cursor
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(0, { start_lnum, start_col - 1 })

  -- Use visual selection to select the range
  vim.cmd 'normal! v'
  vim.api.nvim_win_set_cursor(0, { end_lnum, math.max(end_col - 1, 0) })
end
function query_all_injected_trees(query, quicklist_method)
  assert(quicklist_method == 'r' or quicklist_method == 'a' or quicklist_method == 'f' or quicklist_method == ' ' or quicklist_method == nil)
  quicklist_method = quicklist_method or 'r'
  -- {action} values:		*setqflist-action* *E927*
  -- 'a'	The items from {list} are added to the existing
  -- 	quickfix list.  If there is no existing list, then a
  -- 	new list is created.
  --
  -- 'r'	The items from the current quickfix list are replaced
  -- 	with the items from {list}.  This can also be used to
  -- 	clear the list: >vim
  -- 		call setqflist([], 'r')
  --
  -- 'u'	Like 'r', but tries to preserve the current selection
  -- 	in the quickfix list.
  -- 'f'	All the quickfix lists in the quickfix stack are
  -- 	freed.

  if query == nil or query == '' then
    error 'Pass a query like [[(text) @text]] to the function. quotes around query are optional.'
  end
  local bufnr = vim.api.nvim_get_current_buf()
  print(query)

  nodes, all_trees = getTSCaptures(query, bufnr)
  if next(nodes) == nil then
    vim.print(filename)
    vim.print 'No matches found. The following languages where searched'
    local langs = {}
    for key, value in pairs(all_trees) do
      table.insert(langs, value.lang)
    end
    vim.print(langs)
    return
  end
  qf_entries = {}
  for _, node in ipairs(nodes) do
    local sr, sc, er, ec = node:range()
    local ok, text = pcall(ts.get_node_text, node, bufnr)
    table.insert(qf_entries, {
      bufnr = bufnr,
      lnum = sr + 1,
      end_lnum = er + 1,
      col = sc + 1,
      end_col = ec + 1,
      text = text,
    })
  end
  vim.fn.setqflist(qf_entries, quicklist_method)
end

local function select_current_qf_item()
  local qf_list = vim.fn.getqflist()
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  local item = qf_list[idx]

  if not item or not item.bufnr or item.bufnr == 0 then
    return
  end

  local bufnr = item.bufnr
  local start_lnum = item.lnum
  local start_col = item.col
  local end_lnum = item.end_lnum or item.lnum
  local end_col = item.end_col - 1 or (item.col + 1)
  -- Switch to the buffer and move the cursor
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(0, { start_lnum, start_col - 1 })

  -- Use visual selection to select the range
  vim.cmd 'normal! v'
  vim.api.nvim_win_set_cursor(0, { end_lnum, math.max(end_col - 1, 0) })
end

vim.api.nvim_create_user_command('QueryTSCapture', function(opts)
  -- example call
  --QueryTS [[(text) @text]] -r
  --the @text means the left query will be in the capture group and be put into the quickfix
  -- QueryTS [[(assignment left: (_)@lhs)]] -r
  -- is a more advanced query. it queries all assignments, which have a left hand side
  -- the left hand side can contain anything (_). this anything is put into the capture group @lhs
  -- without the @SomeIdentifier it wouldnt work
  -- queries/capture groups can be found here 
  --/home/ubuntu/.local/share/nvim/lazy/nvim-treesitter-textobjects/queries/python/textobjects.scm
  local capture = opts.args
  local flag = string.match(capture, '%-(%a)')
  if flag then
    local cleaned = string.gsub(capture, '%-' .. flag, '', 1)
    capture = vim.trim(cleaned)
  end
  simple_query(capture, flag)
end, { nargs = 1 })

vim.api.nvim_create_user_command('QueryTS', function(opts)
  -- example call
  --QueryTS [[(text) @text]] -r
  --the @text means the left query will be in the capture group and be put into the quickfix
  -- QueryTS [[(assignment left: (_)@lhs)]] -r
  -- is a more advanced query. it queries all assignments, which have a left hand side
  -- the left hand side can contain anything (_). this anything is put into the capture group @lhs
  -- without the @SomeIdentifier it wouldnt work
  local query = opts.args
  local flag = string.match(query, '%-(%a)')
  if flag then
    local cleaned = string.gsub(query, '%-' .. flag, '', 1)
    query = vim.trim(cleaned)
  end

  query_all_injected_trees(query, flag)
end, { nargs = 1 })
vim.api.nvim_create_user_command('SelectQuickList', select_current_qf_item, {})
vim.api.nvim_create_user_command('Clearquickfix', function()
  vim.fn.setqflist({}, ' ')
end, {})
