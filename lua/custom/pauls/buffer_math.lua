-- generated with claude code Fable
-- Evaluate a block of "| formula" lines around the cursor.
--   | a = 2        -- assignment (plain identifier on the left)
--   | a =          -- empty RHS -> filled with 2
--   | a+3 =        -- empty RHS -> filled with 5
-- To recompute a line, delete everything after its '='.


local function eval_formula_block()
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(0)

  local function is_pipe(lnum)
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
    return line ~= nil and line:match '^%s*|' ~= nil
  end

  if not is_pipe(cur) then
    vim.notify("No '|' formula line under cursor", vim.log.levels.WARN)
    return
  end

  -- expand to the contiguous block of '|' lines
  local first, last = cur, cur
  while first > 1 and is_pipe(first - 1) do
    first = first - 1
  end
  while last < total and is_pipe(last + 1) do
    last = last + 1
  end

  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)

  -- sandbox: variables live here, math.* is reachable (sin, pi, sqrt, ...)
  local env = setmetatable({}, { __index = math })

  local function eval(expr)
    local chunk, err
    if setfenv then -- LuaJIT / Lua 5.1
      chunk, err = loadstring('return ' .. expr, 'formula')
      if chunk then
        setfenv(chunk, env)
      end
    else -- Lua 5.2+
      chunk, err = load('return ' .. expr, 'formula', 't', env)
    end
    if not chunk then
      return nil, err
    end
    local ok, res = pcall(chunk)
    if not ok then
      return nil, res
    end
    return res
  end

  local function fmt(v)
    if type(v) == 'number' and v == math.floor(v) and math.abs(v) < 1e15 then
      return string.format('%d', v)
    end
    return type(v) == 'number' and string.format('%.10g', v) or tostring(v)
  end

  local changed = false
  for i, line in ipairs(lines) do
    local prefix, lhs, rhs = line:match '^(%s*|%s*)(.-)%s*=%s*(.-)%s*$'
    if lhs and lhs ~= '' then
      if rhs ~= '' then
        -- assignment only when LHS is a plain identifier (e.g. "a = 2")
        if lhs:match '^[%a_][%w_]*$' then
          local val, err = eval(rhs)
          if val ~= nil then
            env[lhs] = val
          else
            vim.notify(('line %d: %s'):format(first + i - 1, err), vim.log.levels.WARN)
          end
        end
      else
        -- empty RHS: evaluate the LHS and write the result after '='
        local val, err = eval(lhs)
        if val ~= nil then
          lines[i] = prefix .. lhs .. ' = ' .. fmt(val)
          changed = true
        else
          vim.notify(('line %d: %s'):format(first + i - 1, err), vim.log.levels.WARN)
        end
      end
    end
  end

  if changed then
    vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)
  end
end

vim.api.nvim_create_user_command('EvalFormulas', eval_formula_block, {})
vim.keymap.set('n', '<leader>=', eval_formula_block, { desc = 'Evaluate | formula block' })
