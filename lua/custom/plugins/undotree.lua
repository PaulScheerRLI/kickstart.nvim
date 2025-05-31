return {
  'mbbill/undotree',
  config = function()
    if string.find(string.lower(vim.loop.os_uname().sysname), 'windows') > 0 then
      vim.g.undotree_DiffCommand = 'FC'
    end
  end,
}
