return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      enabled = function()
        local disabled_filetypes = { 'markdown' }
        return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
      end,
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = true,
          window = { border = 'rounded' },
        },
        -- brenoprata10/nvim-highlight-colors integration
        menu = {
          border = 'rounded',
          draw = {
            components = {
              -- customize the drawing of kind icons
              kind_icon = {
                text = function(ctx)
                  -- default kind icon
                  local icon = ctx.kind_icon
                  -- if LSP source, check for color derived from documentation
                  if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= '' then
                      icon = color_item.abbr
                    end
                  end
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  -- default highlight group
                  local highlight = 'BlinkCmpKind' .. ctx.kind
                  -- if LSP source, check for color derived from documentation
                  if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      highlight = color_item.abbr_hl_group
                    end
                  end
                  return highlight
                end,
              },
            },
          },
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },
    },
  },
  {
    'Exafunction/windsurf.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('codeium').setup {
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,
          key_bindings = {
            -- Accept the current completion.
            accept = '<Tab>',
            -- Accept the next word.
            accept_word = '<leader><Tab>',
            -- Accept the next line.
            accept_line = '<leader><leader><Tab>',
            -- Clear the virtual text.
            clear = '<leader>[',
            -- Cycle to the next completion.
            next = '<M-]>',
            -- Cycle to the previous completion.
            prev = '<M-[>',
          },
        },
      }
      require('codeium.virtual_text').set_statusbar_refresh(function()
        require('lualine').refresh()
      end)
    end,
  },
}
