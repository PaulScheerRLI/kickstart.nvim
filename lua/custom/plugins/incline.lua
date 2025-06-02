-- For a floating filename in the top right corner
return {
  'b0o/incline.nvim',
  config = function()
    require('incline').setup()
  end,
  -- Optional: Lazy load Incline
  event = 'VeryLazy',
}
