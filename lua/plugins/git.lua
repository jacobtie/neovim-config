return {
  -- Git commands
  'tpope/vim-fugitive',
  -- :GBrowse to open in GH
  'tpope/vim-rhubarb',
  {
    'akinsho/git-conflict.nvim',
    tag = 'v2.1.0',
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
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
      vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = '[G]it [P]review' })
    end,
  },
  -- It is possible to do file blames with gitsigns but git-blame is much more performant
  -- and has more features
  {
    'f-person/git-blame.nvim',
    config = function()
      require('gitblame').setup { enable = true }
      vim.keymap.set('n', '<leader>gb', ':GitBlameOpenCommitURL<CR>', { desc = '[G]it [B]lame' })
      vim.g.gitblame_message_when_not_committed = 'Uncommitted changes'
    end,
  },
}
