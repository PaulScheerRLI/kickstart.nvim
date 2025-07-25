return {
  'christoomey/vim-tmux-navigator',
  lazy = true,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  keys = {
    { '<C-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
    { '<C-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
    { '<C-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
    { '<C-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
    -- { '<C-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
  },
}
