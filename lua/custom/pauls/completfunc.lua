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
  local filtered = files
  if text ~= '' then
    filtered = vim.fn.matchfuzzy(files, text)
  end
  return filtered
end

function _G.multi_find(text, extra_directories)
  local cwd_before = vim.fn.getcwd()
  local matches = my_find(text, {})
  for key, value in pairs(extra_directories) do
    vim.api.nvim_set_current_dir(value)
    local new_matches = my_find(text, {})
    vim.api.nvim_set_current_dir(cwd_before)
    vim.list_extend(matches, new_matches)
  end
  return matches
end

--NOTE: Define paths/extradirs in local project specific .nvim.lua
--
-- function _G.customFileSearch(findstart, base)
--   if findstart == 1 then
--     --  Return the column where completion starts (0-indexed)
--     local col = vim.fn.col '.'
--     local line = vim.api.nvim_get_current_line()
--
--     -- col is 0-indexed; Lua strings are 1-indexed
--     local pos = col -- start at current char (1-indexed = col+1, but we walk back)
--
--     -- If already on whitespace, no WORD here
--     -- Walk backwards to find start of WORD
--     while pos > 0 and not line:sub(pos, pos):match '%s' do
--       pos = pos - 1
--     end
--     return pos
--   else
--     -- " Return matches for a:base
--     NOTE: define extra directories somewhere
--     return multi_find(base, extra_directories)
--   end
-- end
--
--
-- vim.opt.completefunc = 'v:lua.customFileSearch'
--

-- Only add autocommand in projects where u want django-cotton search
-- For going to cotton files automaticlly
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
-- 	pattern = { "*.html", "*.htmldjango" },
-- 	group = vim.api.nvim_create_augroup("SetIncludeExpressionCotton", { clear = true }),
-- 	callback = function()
-- 			vim.opt_local.includeexpr = "v:lua.CottonIncludeExpr(v:fname)"
-- 		-- vim.opt_local.suffixesadd:append(".html")
-- 		-- vim.opt_local.path:append("**")
-- 	end,
-- })
--

function _G.CottonIncludeExpr(fname)
  local s = fname
  if fname:match '^c%-' then
    print('matched cotton')
    s = s:gsub('^c%-', '')
    s = s:gsub('%.', '/'):gsub('-', '_')
  end
  return s
end

local builtin = require 'telescope.builtin'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local function find_args_files()
  local args = vim.fn.argv() -- get current arglist
  if #args == 0 then
    print 'Argument list is empty'
    return
  end

  -- -- extract unique file paths from quickfix list
  -- local files = {}
  -- local seen = {}
  -- for _, item in ipairs(qflist) do
  --   filename = vim.api.nvim_buf_get_name(item.bufnr)
  --   if filename and not seen[filename] then
  --     table.insert(files, filename)
  --     seen[filename] = true
  --   end
  -- end
  -- NOTE: To pass quickfix files to args just use :cfdo argadd %

  pickers
    .new({}, {
      prompt_title = 'Arglist Files',
      finder = finders.new_table {
        results = args,
      },
      sorter = conf.file_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd('edit ' .. vim.fn.fnameescape(entry[1]))
        end)
        return true
      end,
    })
    :find()
end
local function grep_args_files()
  local args = vim.fn.argv() -- get current arglist
  if #args == 0 then
    print 'Argument list is empty'
    return
  end

  builtin.live_grep {
    prompt_title = 'Grep in Args Files',
    search_dirs = args, -- restrict search to these files/directories
    additional_args = function()
      return { '--smart-case', '--no-ignore' } -- optional ripgrep flags
    end,
  }
end

-- example keymap
vim.keymap.set('n', '<leader>ggq', grep_args_files, { desc = 'Grep inside args' })
vim.keymap.set('n', '<leader>gfq', find_args_files, { desc = 'Find Files in args' })
