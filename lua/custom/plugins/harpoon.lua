return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',

  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>ah', function()
      harpoon:list():add()
      local file = vim.fn.expand '%'
      print('Added to harpoon: ' .. file)
    end, { desc = '<Leader> [a]dd to [h]arpoon' })
    vim.keymap.set('n', '<C-s>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    -- destroys fast move between windows
    -- vim.keymap.set('n', '<C-h>', function()
    -- harpoon:list():select(1)
    -- end)
    vim.keymap.set('n', '<C-t>', function()
      harpoon:list():select(1)
    end, { desc = 'First Harpoon' })
    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():select(2)
    end, { desc = 'Second Harpoon' })
    --vim.keymap.set('n', '<C-s>', function()
    --  harpoon:list():select(4)
    --end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end, { desc = 'Previous Harpoon' })
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end, { desc = 'Next Harpoon' })
    --
    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<C-e>', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })
  end,
}
