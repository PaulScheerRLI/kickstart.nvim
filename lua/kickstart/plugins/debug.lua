-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    'mfussenegger/nvim-dap-python',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F8>',
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F4>',
      function()
        require('dap').focus_frame()
      end,
      desc = 'Debug: Focus Frame / Execution Line',
    },
    {
      '<F6>',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Debug: Debug till cursor',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    require('dap').set_exception_breakpoints { 'raised', 'uncaught' }
    vim.keymap.set('n', '<leader>ri', function()
      local line = vim.api.nvim_get_current_line()
      dap.repl.open()
      dap.repl.execute(line)
    end, { desc = 'Insert current line to dap Repl' })
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })

    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#fff0ff' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffccff' })
    -- Not used. instead we use the tokyonight hl group DapStoppedLine
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#e60e44' })
    local breakpoint_icons = { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    -- local breakpoint_icons = vim.g.have_nerd_font
    --  and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl
      if type == 'Stopped' then
        hl = 'DapStoppedLine'
        vim.fn.sign_define(tp, { text = icon, linehl = hl, texthl = 'DapStop', numhl = 'DapStop' })
      else
        hl = 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end
      -- local hl = (type == 'Stopped') and 'DapStoppedLine' or 'DapBreak'
      -- vim.fn.sign_define(tp, { text = icon, linehl = hl, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    require('dap').configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'file:args with not justMyCode',
        program = '${file}',
        args = function()
          local args_string = vim.fn.input 'Arguments: '
          local utils = require 'dap.utils'
          if utils.splitstr and vim.fn.has 'nvim-0.10' == 1 then
            return utils.splitstr(args_string)
          end
          return vim.split(args_string, ' +')
        end,
        variablePresentation = {
          all = 'group',
        },
        justMyCode = false,
        console = 'integratedTerminal',
      },
    }
    table.insert(require('dap').configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Django manage.py with custom args',
      console = 'integratedTerminal',
      args = function()
        local args_string = vim.fn.input 'Arguments: '
        local utils = require 'dap.utils'
        if utils.splitstr and vim.fn.has 'nvim-0.10' == 1 then
          return utils.splitstr(args_string)
        end
        return vim.split(args_string, ' +')
      end,
      django = true,
      program = vim.loop.cwd() .. '/manage.py',
      variablePresentation = {
        all = 'hide',
        class = 'group',
        protected = 'group',
        special = 'group',
        -- function cant be set because its a protected name by lua
      },
    })
    table.insert(require('dap').configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Django runserver WITH reload',
      args = { 'runserver' },
      django = true,
      program = vim.loop.cwd() .. '/manage.py',
      variablePresentation = {
        all = 'hide',
        class = 'group',
        protected = 'group',
        special = 'group',
        -- function cant be set because its a protected name by lua
      },
    })
    table.insert(require('dap').configurations.python, {
      type = 'python',
      request = 'launch',
      django = true,
      name = 'Django runserver --no reload',
      args = { 'runserver', '--noreload' },
      program = vim.loop.cwd() .. '/manage.py',
      variablePresentation = {
        all = 'hide',
        class = 'group',
        protected = 'group',
        special = 'group',
        -- function cant be set because its a protected name by lua
      },
    })
    require('dap-python').setup 'python'

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
