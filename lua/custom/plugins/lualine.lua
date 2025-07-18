--   You can add your own plugins here or in other files in this directory!
--   z
--  I promise not to create any merge conflicts in this directory .)
--
-- See the kickstart.nvim README for more information
--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  local win_width = vim.fn.winwidth(0)
  return function(str)
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      local no_vowels = str:gsub('[aeiouAEIOU]', '')
      return no_vowels:sub(-trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  config = function()
    local function window()
      return vim.api.nvim_win_get_number(0)
    end
    local custom_tokyonight = require 'lualine.themes.tokyonight-night'
    local tokyonight_moon = require 'lualine.themes.tokyonight' -- Change the background of inactive lualine/statusline to slightly darker

    -- Change the background of inactive lualine/statusline to slightly darker

    custom_tokyonight.inactive.c.bg = tokyonight_moon.inactive.c.bg
    custom_tokyonight.normal.c.bg = tokyonight_moon.normal.c.bg
    require('lualine').setup {
      --sections = {
      --          lualine_c = {
      --            'navic',
      --
      --            -- Component specific options
      --            color_correction = nil, -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
      --            -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
      --            -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
      --            --	 be enough when the lualine section isn't changing colors based on the mode.
      --            -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
      --            --	 the current section.
      --
      --            navic_opts = nil, -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
      --          },
      --},
      -- OR in winbar
      options = {
        icons_enabled = true,
        theme = custom_tokyonight,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {
            'dap-repl',
            'better_term',
          },
        },
        ignore_focus = {
          'dapui_watches',
          'dapui_breakpoints',
          'dapui_scopes',
          'dapui_console',
          'dapui_stacks',
          'dap-repl',
        },
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'branch', fmt = trunc(1920 / 2, 15, nil, true) }, 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = { window },
      },
      tabline = {},
      winbar = {
        lualine_c = {
          'navic',
          color_correction = nil,
          navic_opts = nil,
        },
        lualine_x = { 'filename' },
        lualine_z = { 'lsp_status' },
      },
      inactive_winbar = {
        lualine_x = { 'filename' },
      },
      extensions = {},
    }
  end,
}
