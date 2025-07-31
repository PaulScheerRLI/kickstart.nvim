safestate = false
lastmode = ''
function start_repatable()
  register()
  vim.api.nvim_create_autocmd('SafeState', {
    group = vim.api.nvim_create_augroup('auto_repeat', { clear = true }),
    callback = function()
      safestate = true
      if tablelength(storage) > 1 then
        local command = table.concat(storage)
        if string.find(command, '@') then
          storage = {}
          return
        end
        print(command)
        vim.fn.setreg('w', command)
      end
      storage = {}
      -- local mode = vim.fn.mode()
      -- if lastmode == mode then
      --   return
      -- end
      -- lastmode = mode
      -- print(mode)
      -- if vim.fn.mode() then
      --   retu
      -- end
    end,
  })
end
storage = {}
local ns_id = vim.api.nvim_create_namespace 'auto_repeat'
function register()
  print 'register'
  vim.on_key(function(key, typed)
    table.insert(storage, key)
  end, ns_id, {})
end

start_repatable()

function tablelength(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end
-- ssdf asdf asa asdf dafsfasddfg
