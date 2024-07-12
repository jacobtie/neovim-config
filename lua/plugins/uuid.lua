return {
  'TrevorS/uuid-nvim',
  config = function()
    require('uuid-nvim').setup {
      case = 'lower',
      quotes = 'none',
      insert = 'before',
    }
    vim.keymap.set('i', '<C-u>', require('uuid-nvim').insert_v4)
  end,
}
