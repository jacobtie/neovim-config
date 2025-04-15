local is_prettier_disabled = function(bufnr)
  local info = require('conform').get_formatter_info('prettier', bufnr)
  return not info.available
end

return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = {
        c = true,
        cpp = true,
        typescript = is_prettier_disabled(bufnr),
        javascript = is_prettier_disabled(bufnr),
        vue = is_prettier_disabled(bufnr),
      }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'prettier' },
      javascript = { 'prettier' },
      vue = { 'prettier' },
    },
    formatters = {
      prettier = {
        require_cwd = true,
      },
    },
  },
}
