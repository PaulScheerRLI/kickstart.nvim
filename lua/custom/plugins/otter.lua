-- :OtterActivate does not seem to work run
-- :lua require'otter'.activate()
-- instead
return {
  'jmbuhr/otter.nvim',
  ft = { 'markdown', 'rmd', 'quarto', 'html', 'htmldjango' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {},
}
