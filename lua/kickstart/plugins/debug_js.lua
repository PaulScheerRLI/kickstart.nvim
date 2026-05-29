print 'hello from debug_js' -- setup dap config by VsCode launch.json file

local dap = require 'dap'
--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
function get_pkg_path(pkg, path)
  pcall(require, 'mason')
  local root = vim.env.MASON or (vim.fn.stdpath 'data' .. '/mason')
  path = path or ''
  local ret = root .. '/packages/' .. pkg .. '/' .. path
  return ret
end

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
      -- "/home/ubuntu/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
      '${port}',
    },
  },
}

dap.adapters['pwa-chrome'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
      '${port}',
    },
  },
}

local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }
local dap_vscode = require 'dap.ext.vscode'
local json = require 'plenary.json'
---@diagnostic disable-next-line: duplicate-set-field
dap_vscode.json_decode = function(str)
  return vim.json.decode(json.json_strip_comments(str, {}))
end

dap_vscode.type_to_filetypes['pwa-node'] = js_filetypes

-- Ensure all configs have a cwd, defaulting to workspaceFolder.
-- This fixes launch.json configs that omit the cwd property.
dap.listeners.on_config['ensure_cwd'] = function(config)
  if not config.cwd and vim.tbl_contains({ 'pwa-node', 'pwa-chrome' }, config.type) then
    config.cwd = '${workspaceFolder}'
  end
  return config
end

for _, language in ipairs(js_filetypes) do
  dap.configurations[language] = {
    -- Debug single nodejs files
    {
      name = 'Launch file',
      type = 'pwa-node',
      request = 'launch',
      program = '${file}',
      cwd = '${workspaceFolder}',
      args = { '${file}' },
      sourceMaps = true,
      sourceMapPathOverrides = {
        ['./*'] = '${workspaceFolder}/src/*',
      },
    },
    -- Debug nodejs processes (make sure to add --inspect when you run the process)
    {
      name = 'Attach',
      type = 'pwa-node',
      request = 'attach',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
    },
    {
      -- https://alpha2phi.medium.com/neovim-for-beginners-javascript-typescript-debugging-bd0fc8e16657
      type = 'pwa-chrome',
      name = 'Attach - Remote Debugging Django-simba',
      request = 'attach',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      port = 9222,
      webRoot = '${workspaceFolder}',
      pathMapping = {
        ['/static/custom.js'] = '${workspaceFolder}/templates/js/custom.js',
      },
    },
    {
      -- https://alpha2phi.medium.com/neovim-for-beginners-javascript-typescript-debugging-bd0fc8e16657
      type = 'pwa-chrome',
      name = 'Attach - Remote Debugging',
      request = 'attach',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      port = 9222,
      webRoot = '${workspaceFolder}',
    },
    {
      name = 'Debug Jest Tests',
      type = 'pwa-node',
      request = 'launch',
      runtimeExecutable = 'node',
      runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest', '--runInBand' },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
      -- args = {'${file}', '--coverage', 'false'},
      -- sourceMaps = true,
      -- skipFiles = {'node_internals/**', 'node_modules/**'},
    },
    -- Debug web applications (client side)
    {
      name = 'Launch & Debug Chrome',
      type = 'pwa-chrome',
      request = 'launch',

      port = 9222,
      url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:3000' }, function(url)
            if url == nil or url == '' then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end,
      webRoot = vim.fn.getcwd(),
      protocol = 'inspector',
      sourceMaps = true,
      userDataDir = false,
      resolveSourceMapLocations = {
        '${workspaceFolder}/**',
        '!**/node_modules/**',
      },

      -- From https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/dap.lua
      -- To test how it behaves
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
      sourceMapPathOverrides = {
        ['./*'] = '${workspaceFolder}/src/*',
      },
    },
    {
      name = '----- ↑ launch.json configs (if available) ↑ -----',
      type = '',
      request = 'launch',
    },
  }
end
