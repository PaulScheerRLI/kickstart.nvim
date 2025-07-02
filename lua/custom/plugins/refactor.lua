return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  config = function()
    require('refactoring').setup {
      prompt_func_return_type = {
        go = false,
        java = false,

        python = true,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,

        python = true,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {
        -- add a custom printf statement for cpp
        cpp = {
          'std::cout << "%s" << std::endl;',
        },
      },

      print_var_statements = {

        -- add a custom print var statement for cpp
        cpp = {
          'printf("a custom statement %%s %s", %s)',
        },
      },
      show_success_message = false, -- shows a message with information about the refactor on success
      -- i.e. [Refactor] Inlined 3 variable occurrences
    }
    -- prompt for return type

    -- load refactoring Telescope extension
    require('telescope').load_extension 'refactoring'
    vim.keymap.set({ 'n', 'x' }, '<leader>RR', function()
      require('telescope').extensions.refactoring.refactors()
      -- require('refactoring').select_refactor { prefer_ex_cmd = true }
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
  end,
}
