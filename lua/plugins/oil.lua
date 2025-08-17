return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
      }
      vim.keymap.set('n', '<leader>-', '<CMD>Oil<CR>', { desc = 'Open [O]il' })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'OilActionsPost',
        callback = function(event)
          local Snacks = require 'snacks'
          if event.data.actions.type == 'move' then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
  },
  {
    'JezerM/oil-lsp-diagnostics.nvim',
    dependencies = { 'stevearc/oil.nvim' },
    opts = {},
  },
}
