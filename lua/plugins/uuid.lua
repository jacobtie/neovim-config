return {
  'TrevorS/uuid-nvim',
  config = function()
    require('uuid-nvim').setup {
      case = 'lower',
      quotes = 'none',
      after = false,
    }
    vim.keymap.set('i', '<C-u>', require('uuid-nvim').insert_v4)
  end,
}
