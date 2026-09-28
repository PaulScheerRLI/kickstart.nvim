return {
  {
    'andymass/vim-matchup',
    ft = { 'html',  'python', 'lua', 'py' },
    enabled = true,
    -- enabled = function()
    --   return false
    --   if vim.fn.has 'wsl' == 1 then
    --     return true
    --   end
    --   -- vim.print 'matchup is disabled for windows since its kinda laggy'
    --   return false
    -- end,
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
    -- NOTE: lazy.nvim's automatic opts->setup wiring guesses the Lua module
    -- name from the plugin name ('vim-matchup' -> 'matchup'), but this
    -- plugin's actual module is 'match-up', so the guess fails silently and
    -- `opts` below was never being passed to setup() at all. Call it
    -- explicitly instead.
    config = function(_, opts)
      require('match-up').setup(opts)
    end,
    ---@type matchup.Config
    opts = {
      matchup_enabled = true,
      treesitter = {
        stopline = 500,
        -- Without this, matchup's default treesitter-based matching silently
        -- ignores b:match_words for filetypes with a treesitter parser (e.g.
        -- html), which breaks django-plus.vim's {% if %}/{% endif %} pairs
        -- (b:match_words is correctly populated, but never consulted).
        include_match_words = true,
      },
      -- NOTE: This seems to be a very important setting. setting to 1 makes it way less laggg i thinkg
      matchup_matchparen_deferred = 1,
      -- does not seem to work, so disabled
      matchup_transmute_enabled = 0,
    },
  },
}
