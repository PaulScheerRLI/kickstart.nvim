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
    { '<C-h>', '<cmd><C-U>TmuxNavigateLeft<cr>', mode = 'n' },
    { '<C-j>', '<cmd><C-U>TmuxNavigateDown<cr>', mode = 'n' },
    { '<C-k>', '<cmd><C-U>TmuxNavigateUp<cr>', mode = 'n' },
    { '<C-l>', '<cmd><C-U>TmuxNavigateRight<cr>', mode = 'n' },
    { '<C-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>', mode = 'n' },
    -- to escape from terminal mode first leave terminal mode
    { '<C-h>', '<C-\\><C-n><cmd><C-U>TmuxNavigateLeft<cr>', mode = 't' },
    { '<C-j>', '<C-\\><C-n><cmd><C-U>TmuxNavigateDown<cr>', mode = 't' },
    { '<C-k>', '<C-\\><C-n><cmd><C-U>TmuxNavigateUp<cr>', mode = 't' },
    { '<C-l>', '<C-\\><C-n><cmd><C-U>TmuxNavigateRight<cr>', mode = 't' },
    { '<C-\\>', '<C-\\><C-n><cmd><C-U>TmuxNavigatePrevious<cr>', mode = 't' },
  },
}
