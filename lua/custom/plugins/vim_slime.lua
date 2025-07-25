return {
  'jpalardy/vim-slime',
  config = function()
    if vim.env.TMUX ~= nil then
      vim.g.slime_target = 'tmux'
    else
      vim.g.slime_target = 'neovim'
    end
  end,
}
