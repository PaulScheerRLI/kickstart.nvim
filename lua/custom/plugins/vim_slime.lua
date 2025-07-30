-- THIS HAS TO HAPPEN BEFORE THE PLUGIN IS SETUP
if vim.env.TMUX ~= nil then
  vim.g.slime_target = 'tmux'
else
  vim.g.slime_target = 'neovim'
end
return {
  'jpalardy/vim-slime',
  init = function()
    vim.g.slime_no_mappings = 1
  end,
  config = function()
    -- Define keymaps for Slime in Lua
    local opts = { noremap = false, silent = true }

    -- Visual mode: send visual selection
    vim.keymap.set('x', '<leader>rj', '<Plug>SlimeRegionSend', opts)
    vim.keymap.set('n', '<leader>rj', '<Plug>SlimeParagraphSend', opts)
    vim.keymap.set('n', '<leader>rl', '<Plug>SlimeLineSend', opts)

    -- Normal mode: send based on motion or text object
    vim.keymap.set('n', '<leader>rm', '<Plug>SlimeMotionSend', opts)

    -- Normal mode: send line
    vim.keymap.set('n', '<leader>ss', '<Plug>SlimeLineSend', opts)
  end,
}
