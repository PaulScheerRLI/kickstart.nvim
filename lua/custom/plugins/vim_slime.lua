-- vim-slime's plugin/slime.vim wires up TermOpen/TermClose tracking for
-- the "neovim" target exactly ONCE, gated on whatever g:slime_target is
-- at the moment the plugin's own scripts are first sourced (see
-- plugin/slime.vim and autoload/slime/config.vim in vim-slime). If nvim
-- starts inside tmux, g:slime_target is "tmux" at that moment, so
-- channel tracking (g:slime_last_channel) never gets registered for the
-- rest of the session -- swapping to the neovim target later then fails
-- with "Terminal not found", since no terminal channel was ever
-- recorded. init() runs before the plugin's scripts are sourced, so we
-- force the target to "neovim" there to guarantee tracking always gets
-- wired up, then pick the real backend afterwards in config().

local function slime_tmux()
  vim.g.slime_target = 'tmux'
  vim.g.slime_default_config = {
    socket_name = 'default',
    target_pane = '{last}',
  }
  vim.g.slime_dont_ask_default = 0
end

local function slime_neovim()
  vim.g.slime_target = 'neovim'
  vim.g.slime_default_config = {
    jobid = nil, -- let vim-slime ask/select terminal job
  }
  vim.g.slime_dont_ask_default = 0
end

local function slime_detect_backend()
  if vim.env.TMUX ~= nil then
    slime_tmux()
  else
    slime_neovim()
  end
end

-- Swap the active backend at runtime (e.g. testing in a :terminal split
-- while nvim happens to be running inside tmux, or vice versa). Just
-- reassigning g:slime_target isn't enough: every buffer keeps its own
-- cached b:slime_config from the *previous* backend, and vim-slime only
-- re-validates that cache for targets that implement ValidConfig
-- (neovim does; tmux doesn't -- any leftover dict is accepted as
-- "valid" and then crashes on the missing socket_name/target_pane
-- keys). So clear the cached config in every buffer and immediately
-- re-trigger :SlimeConfig for the current one instead of waiting for
-- the next send to fail.
function slime_swap_backend()
  if vim.g.slime_target == 'tmux' then
    slime_neovim()
  else
    slime_tmux()
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    pcall(vim.api.nvim_buf_del_var, buf, 'slime_config')
  end

  vim.notify('vim-slime target -> ' .. vim.g.slime_target)
  vim.cmd 'SlimeConfig'
end

return {
  'jpalardy/vim-slime',
  init = function()
    vim.g.slime_no_mappings = 1
    -- THIS HAS TO HAPPEN BEFORE THE PLUGIN IS SETUP: force "neovim" so
    -- vim-slime's one-time TermOpen/TermClose tracking always registers,
    -- regardless of which backend we actually end up using.
    vim.g.slime_target = 'neovim'
    vim.g.slime_bracketed_paste = 1
  end,
  config = function()
    -- Now that the plugin has loaded (and channel tracking is wired up
    -- either way), pick the backend that actually matches this session.
    slime_detect_backend()

    -- Define keymaps for Slime in Lua
    local opts = { noremap = false, silent = true }

    -- Visual mode: send visual selection
    vim.keymap.set('x', '<leader>rj', '<Plug>SlimeRegionSend', opts)
    vim.keymap.set('n', '<leader>rj', '<Plug>SlimeParagraphSend', opts)
    vim.keymap.set('n', '<leader>rl', '<Plug>SlimeLineSend', opts)

    -- Normal mode: send based on motion or text object
    vim.keymap.set('n', '<leader>rm', '<Plug>SlimeMotionSend', opts)

    -- Normal mode: send line
    vim.keymap.set('n', '<leader>sj', '<Plug>SlimeLineSend', opts)

    -- Normal mode: swap between tmux/neovim backends and reconfigure
    vim.keymap.set('n', '<leader>rb', slime_swap_backend, opts)
  end,
}
