return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {}
    require('oil').toggle_hidden()
    vim.keymap.set('n', '<leader>-', ':Oil<CR>', { desc = 'Open [O]il' })
  end,
}
