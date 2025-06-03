return {
  'mbbill/undotree',
  config = function()
    -- string.find returns nil if not found --> cant compare to 0
    if (string.find(string.lower(vim.loop.os_uname().sysname), 'windows') or 0) > 0 then
      vim.g.undotree_DiffCommand = 'FC'
    end
  end,
}
