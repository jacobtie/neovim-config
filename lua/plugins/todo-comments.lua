return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local Todo = require 'todo-comments'
    local Snacks = require 'snacks'
    Todo.setup { signs = false }
    vim.keymap.set('n', '<leader>ft', Todo.jump_next)
    vim.keymap.set('n', '<leader>fp', Todo.jump_prev)
    ---@diagnostic disable-next-line: undefined-field
    vim.keymap.set('n', '<leader>st', Snacks.picker.todo_comments) -- Show todo comments with snacks picker
  end,
}
