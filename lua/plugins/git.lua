return {
  -- Git commands
  'tpope/vim-fugitive',
  -- :GBrowse to open in GH
  'tpope/vim-rhubarb',
  -- Show and resolve config
  {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup {
        default_mapping = false,
      }
      vim.keymap.set('n', '<leader>co', ':GitConflictChooseOurs<CR>', { desc = '[C]hoose [O]urs' })
      vim.keymap.set('n', '<leader>ct', ':GitConflictChooseTheirs<CR>', { desc = '[C]hoose [T]heirs' })
      vim.keymap.set('n', '<leader>cb', ':GitConflictChooseBoth<CR>', { desc = '[C]hoose [B]oth' })
      vim.keymap.set('n', '<leader>c0', ':GitConflictChooseNone<CR>', { desc = '[C]hoose N[0]ne' })
      vim.keymap.set('n', '<leader>]x', ':GitConflictNextConflict<CR>', { desc = 'Next Conflict' })
      vim.keymap.set('n', '<leader>[x', ':GitConflictPrevConflict<CR>', { desc = 'Previous Conflict' })
    end,
  },
  -- Show git status in the sign column
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
}
