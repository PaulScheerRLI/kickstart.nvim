return {
  'aspeddro/slides.nvim',
  config = function()
    require('slides').setup {
      bin = 'slides', -- path to binary
      fullscreen = true, -- open in fullscree
    }
  end,
}
