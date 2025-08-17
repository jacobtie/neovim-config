return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  config = function()
    local Snacks = require 'snacks'
    Snacks.setup {
      bigfile = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
    }
    vim.keymap.set('n', '<leader>sf', Snacks.picker.files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sg', Snacks.picker.grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', Snacks.picker.diagnostics, { desc = '[S]earch [D]iagnostics' })
  end,
}
