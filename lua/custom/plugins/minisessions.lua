return {
  'echasnovski/mini.sessions',
  config = function()
    require('mini.sessions').setup {
      -- Whether to read default session if Neovim opened without file arguments
      autoread = true,

      -- If false sessions are only written given the :mksession command or explicit
      -- :lua require('mini-sessions').write('some-session')
      autowrite = false,
      -- Whether to write currently read session before quitting Neovim

      -- Directory where global sessions are stored (use `''` to disable)
      directory = '',

      -- File for local session (use `''` to disable)
      file = 'Session.vim',

      -- Whether to force possibly harmful actions (meaning depends on function)
      force = { read = false, write = true, delete = false },

      -- Hook functions for actions. Default `nil` means 'do nothing'.
      hooks = {
        -- Before successful action
        pre = { read = nil, write = nil, delete = nil },
        -- After successful action
        post = { read = nil, write = nil, delete = nil },
      },

      -- Whether to print session path after action
      verbose = { read = true, write = true, delete = true },
    }
  end,

  --[[
    -- Commands for Sessions
    --  :lua MiniSessions.write("My-Foo-Session")
    --  :lua MiniSessions.read("My-Foo-Session")
    --]]
}
