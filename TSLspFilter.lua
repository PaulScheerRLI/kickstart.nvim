local disabled = false

print 'Sourced'
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('TSLspFilter', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    print(client.name .. ' is attaching')
    if client.name ~= 'ltex' and client.name ~= 'ltex_plus' then
      return
    end

    print 'overwriting notify'
    local old_notify = client.notify

    client.notify = function(method, params)
      if disabled or type(method) ~= 'string' then
        return old_notify(method, params)
      end
      -- __AUTO_GENERATED_PRINTF_START__
      print [==[callback#client.notify 1]==] -- __AUTO_GENERATED_PRINTF_END__
      vim.print 'method'
      vim.print(method)
      if true or method == 'textDocument/didChange' and params and params.contentChanges then
        local bufnr = args.buf
        -- __AUTO_GENERATED_PRINTF_START__
        print [==[callback#client.notify#if 2]==] -- __AUTO_GENERATED_PRINTF_END__

        local filtered = {}

        nodes = getTSCaptures([[(text) @text]], bufnr)
        print 'ts query text'
        for _, node in ipairs(nodes) do
          -- vim.print(node)
          -- vim.print(_)
          local text = vim.treesitter.get_node_text(node, bufnr)
          vim.print(text)
          if text:sub(1, 1) == 'U' then
            table.insert(filtered, text)
          end
        end

        print 'changes'
        Params = params
        for _, change in ipairs(params.contentChanges or {}) do
          vim.print(change)
          change.text = table.concat(filtered, ' ')
        end
      end
      return old_notify(method, params)
    end
  end,
})
Params = nil
vim.api.nvim_create_user_command('DisableFooNotifyFilter', function()
  disabled = true
end, {})
