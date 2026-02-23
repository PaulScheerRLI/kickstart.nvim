-- Put this in your init.lua
-- with two args it could be used for vim.opt.findfunc
-- find os specific directory seperator
local sep = package.config:sub(1, 1)

function _G.my_find(text, _)
  -- search in root first
  local files = vim.fn.glob(text .. '*', true, true)
  files = vim.tbl_map(function(f)
    if vim.fn.isdirectory(f) == 1 then
      return f .. sep
    end
    return f
  end, files)
  local filtered
  if text ~= '' then
    filtered = vim.fn.matchfuzzy(files, text)
  else
    filtered = files
  end
  return filtered
end
 
local extra_directories = vim.fn.glob('**/plugins/', true, true)
function _G.multi_find(text)
  local cwd_before = vim.fn.getcwd()
  local matches = my_find(text, {})
  for key, value in pairs(extra_directories) do
    vim.api.nvim_set_current_dir(value)
   local new_matches = my_find(text, {})
    vim.api.nvim_set_current_dir(cwd_before)
    vim.list_extend(matches,new_matches)
  end
  return matches
end

function _G.customFileSearch(findstart, base)
  if findstart == 1 then
    --  Return the column where completion starts (0-indexed)
    local col = vim.fn.col '.'
    local line = vim.api.nvim_get_current_line()

    -- col is 0-indexed; Lua strings are 1-indexed
    local pos = col -- start at current char (1-indexed = col+1, but we walk back)

    -- If already on whitespace, no WORD here
    -- Walk backwards to find start of WORD
    while pos > 0 and not line:sub(pos, pos):match '%s' do
      pos = pos - 1
    end
    return pos
  else
    -- " Return matches for a:base
    return multi_find(base)
  end
end


vim.opt.completefunc = 'v:lua.customFileSearch'

local foo = 'foo bar'
