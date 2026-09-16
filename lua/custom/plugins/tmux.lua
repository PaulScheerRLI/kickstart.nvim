return {
  'christoomey/vim-tmux-navigator',
  lazy = true,
  init = function()
    -- prevent the plugin's own tnoremap (a Vim-only <C-w> escape hack that
    -- doesn't work in Neovim's terminal mode) from overriding the
    -- terminal-mode mappings defined below
    vim.g.tmux_navigator_no_mappings = 1
  end,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', mode = 'n' },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>', mode = 'n' },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>', mode = 'n' },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>', mode = 'n' },
    -- { '<C-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>', mode = 'n' },
    -- to escape from terminal mode first leave terminal mode
    --
    -- this only seems to work for non tmux session
    { '<C-h>', '<C-\\><C-n><cmd>TmuxNavigateLeft<cr>', mode = 't' },
    { '<C-j>', '<C-\\><C-n><cmd>TmuxNavigateDown<cr>', mode = 't' },
    { '<C-k>', '<C-\\><C-n><cmd>TmuxNavigateUp<cr>', mode = 't' },
    { '<C-l>', '<C-\\><C-n><cmd>TmuxNavigateRight<cr>', mode = 't' },
    -- { '<C-\\>', '<C-\\><C-n><cmd><C-U>TmuxNavigatePrevious<cr>', mode = 't' },
  },
}
