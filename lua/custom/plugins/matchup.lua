return {
  {
    'andymass/vim-matchup',
    -- ft = { 'html', 'python', 'lua', 'py' },
    enabled = function()
      if vim.fn.has 'wsl' == 1 then
        return true
      end
      -- vim.print 'matchup is disabled for windows since its kinda laggy'
      return false
    end,
    -- init = function()
    --   -- modify your configuration vars here
    --   vim.g.matchup_treesitter_stopline = 500
    --
    --   -- or call the setup function provided as a helper. It defines the
    --   -- configuration vars for you
    --   require('match-up').setup({
    --     treesitter = {
    --       stopline = 500
    --     }
    --   })
    -- end,
    -- or use the `opts` mechanism built into `lazy.nvim`. It calls
    -- `require('match-up').setup` under the hood
    ---@type matchup.Config
    opts = {
      matchup_enabled = true,
      treesitter = {
        stopline = 500,
      },
      -- NOTE: This seems to be a very important setting. setting to 1 makes it way less laggg i thinkg
      matchup_matchparen_deferred = 1,
      -- does not seem to work, so disabled
      matchup_transmute_enabled = 0,
    },
  },
}
