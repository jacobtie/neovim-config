return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function windsurf_status()
      local status = require('codeium.virtual_text').status()
      if status.state == 'idle' then
        return ''
      end
      if status.state == 'waiting' then
        return 'Loading...'
      end
      if status.state == 'completions' and status.total > 0 then
        return string.format('%d/%d', status.current, status.total)
      end
      return ''
    end
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { windsurf_status },
        lualine_y = { 'filetype', 'lsp_status' },
        lualine_z = { 'progress', 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {
        'oil',
        'fugitive',
        'mason',
        'lazy',
        'trouble',
        'quickfix',
      },
    }
  end,
}
