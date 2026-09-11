-- github.com/nvim-treesitter/nvim-treesitter-textobjects
-- use operators on lefthand or righthand side
vim.keymap.set({ 'x', 'o' }, 'sr', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@assignment.rhs', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'sl', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@assignment.lhs', 'textobjects')
end)

vim.keymap.set({ 'x', 'o' }, 'aa', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@attribute', 'textobjects')
end)

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    -- vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    -- put your config here
    require('nvim-treesitter-textobjects').setup {
      select = {
      --   -- Automatically jump forward to textobj, similar to targets.vim
      --   -- lookahead = true,
      --   -- You can choose the select mode (default is charwise 'v')
      --   --
      --   -- Can also be a function which gets passed a table with the keys
      --   -- * query_string: eg '@function.inner'
      --   -- * method: eg 'v' or 'o'
      --   -- and should return the mode ('v', 'V', or '<c-v>') or a table
      --   -- mapping query_strings to modes.
      --   -- selection_modes = {
      --   --   -- ['@parameter.outer'] = 'v', -- charwise
      --   --   -- ['@function.outer'] = 'V', -- linewise
      --   --   -- ['@class.outer'] = '<c-v>', -- blockwise
      --   -- },
      --   -- If you set this to `true` (default is `false`) then any textobject is
      --   -- extended to include preceding or succeeding whitespace. Succeeding
      --   -- whitespace has priority in order to act similarly to eg the built-in
      --   -- `ap`.
      --   --
      --   -- Can also be a function which gets passed a table with the keys
      --   -- * query_string: eg '@function.inner'
      --   -- * selection_mode: eg 'v'
      --   -- and should return true of false
        include_surrounding_whitespace = false,
      },
    }
  end,
}

-- return {
--   'nvim-treesitter/nvim-treesitter-textobjects',
--   event = 'VeryLazy',
--   dependencies = 'nvim-treesitter',
--   config = function()
--     require('nvim-treesitter.configs').setup {
--       textobjects = {
--         select = {
--           enable = true,
--
--           -- Automatically jump forward to textobj, similar to targets.vim
--           lookahead = true,
--
--           keymaps = {
--             -- use these keymaps just like other textobjects e.g.
--             -- delete outer function wit daf
--             -- You can use the capture groups defined in textobjects.scm
--             ['al'] = '@assignment.lhs',
--             ['ir'] = '@assignment.rhs',
--             ['il'] = '@assignment.lhs',
--             ['ir'] = '@assignment.rhs',
--             ['af'] = '@function.outer',
--             ['if'] = '@function.inner',
--             ['ac'] = '@class.outer',
--             -- You can optionally set descriptions to the mappings (used in the desc parameter of
--             -- nvim_buf_set_keymap) which plugins like which-key display
--             ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
--             -- You can also use captures from other query groups like `locals.scm`
--             ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
--           },
--           -- You can choose the select mode (default is charwise 'v')
--           --
--           -- Can also be a function which gets passed a table with the keys
--           -- * query_string: eg '@function.inner'
--           -- * method: eg 'v' or 'o'
--           -- and should return the mode ('v', 'V', or '<c-v>') or a table
--           -- mapping query_strings to modes.
--           selection_modes = {
--             ['@parameter.outer'] = 'v', -- charwise
--             ['@function.outer'] = 'V', -- linewise
--             ['@class.outer'] = '<c-v>', -- blockwise
--           },
--           -- If you set this to `true` (default is `false`) then any textobject is
--           -- extended to include preceding or succeeding whitespace. Succeeding
--           -- whitespace has priority in order to act similarly to eg the built-in
--           -- `ap`.
--           --
--           -- Can also be a function which gets passed a table with the keys
--           -- * query_string: eg '@function.inner'
--           -- * selection_mode: eg 'v'
--           -- and should return true or false
--           include_surrounding_whitespace = false,
--         },
--         { function(a, b) end },
--         -- swap nodes, e.g. a and b above. cursor needs to be on the swapped object
--         swap = {
--           enable = true,
--           swap_next = {
--             ['<leader>a'] = '@parameter.inner',
--           },
--           swap_previous = {
--             ['<leader>A'] = '@parameter.inner',
--           },
--         },
--         move = {
--           enable = true,
--           set_jumps = true, -- whether to set jumps in the jumplist
--
--           goto_next_start = {
--             [']m'] = '@function.outer',
--             -- not all nodes can be by default, text had to be turned on for html in
--             -- text objects dont exist in all  languages
--             --
--             -- after/queries/html/textobjects.scm
--             [']t'] = '@text',
--             [']]'] = { query = '@class.outer', desc = 'Next class start' },
--             --
--             -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
--             [']o'] = '@loop.*',
--             -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
--             --
--             -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
--             -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
--             [']s'] = { query = '@local.scope', query_group = 'locals', desc = 'Next scope' },
--             [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
--           },
--           goto_next_end = {
--             [']M'] = '@function.outer',
--             [']['] = '@class.outer',
--           },
--           goto_previous_start = {
--             ['[m'] = '@function.outer',
--             ['[['] = '@class.outer',
--           },
--           goto_previous_end = {
--             ['[M'] = '@function.outer',
--             ['[]'] = '@class.outer',
--           },
--           -- Below will go to either the start or the end, whichever is closer.
--           -- Use if you want more granular movements
--           -- Make it even more gradual by adding multiple queries and regex.
--           -- goto_next = {
--           --   [']d'] = '@conditional.outer',
--           -- },
--           -- goto_previous = {
--           --   ['[d'] = '@conditional.outer',
--           -- },
--         },
--       },
--     }
--   end,
-- }
