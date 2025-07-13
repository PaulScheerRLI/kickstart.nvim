-- :OtterActivate does not seem to work run
-- :lua require'otter'.activate()
-- instead
return {
  'jmbuhr/otter.nvim',
  event = 'VeryLazy',
  ft = { 'markdown', 'rmd', 'quarto', 'html', 'htmldjango' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {},
}
