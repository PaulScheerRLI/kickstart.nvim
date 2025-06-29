return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  opts = {},
  config = function()
    -- load refactoring Telescope extension
    require('telescope').load_extension 'refactoring'

    vim.keymap.set({ 'n', 'x' }, '<leader>RR', function()
      require('telescope').extensions.refactoring.refactors()
    end)
    -- You can also use below = true here to to change the position of the printf
    -- statement (or set two remaps for either one). This remap must be made in normal mode.
    vim.keymap.set('n', '<leader>RP', function()
      require('refactoring').debug.printf { below = false }
    end)

    -- Print var

    vim.keymap.set({ 'x', 'n' }, '<leader>RV', function()
      require('refactoring').debug.print_var()
    end)
    -- Supports both visual and normal mode

    vim.keymap.set('n', '<leader>RC', function()
      require('refactoring').debug.cleanup {}
    end)
    -- Supports only normal mode
    printf_statements = {
      -- add a custom printf statement for cpp
      cpp = {
        'std::cout << "%s" << std::endl;',
      },
    }
  end,
}
