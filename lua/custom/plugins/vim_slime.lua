-- THIS HAS TO HAPPEN BEFORE THE PLUGIN IS SETUP
if vim.env.TMUX ~= nil then
  vim.g.slime_target = 'tmux'
else
  vim.g.slime_target = 'neovim'
end
return {
  'jpalardy/vim-slime',
  config = function() end,
}
