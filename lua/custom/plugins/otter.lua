-- :OtterActivate does not seem to work run
-- :lua require'otter'.activate()
-- instead
return {
  'jmbuhr/otter.nvim',
  event = 'VeryLazy',
  ft = { 'css', 'markdown', 'rmd', 'quarto', 'html', 'htmldjango' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    write_to_disk = true,
  },
}
