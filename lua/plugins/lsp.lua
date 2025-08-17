-- LSP Configuration & Plugins
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local Snacks = require 'snacks'
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', Snacks.picker.lsp_definitions, '[G]oto [D]efinition')
          map('gD', Snacks.picker.lsp_declarations, '[G]oto [D]eclaration')
          map('gr', Snacks.picker.lsp_references, '[G]oto [R]eferences')
          map('gI', Snacks.picker.lsp_implementations, '[G]oto [I]mplementation')
          map('gt', Snacks.picker.lsp_type_definitions, '[G]oto [T]ype Definition')
          map('gs', Snacks.picker.lsp_symbols, '[D]ocument [S]ymbols')
          map('gW', Snacks.picker.lsp_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local function client_supports_method(c, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return c:supports_method(method, bufnr)
            else
              return c.supports_method(method, { bufnr = bufnr })
            end
          end
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local base_on_attach = vim.lsp.config.eslint.on_attach
      local servers = {
        gopls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = '@vue/typescript-plugin',
                    location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                  },
                },
              },
            },
          },
          filetypes = { 'javascript', 'typescript', 'vue' },
          handlers = {
            ['textDocument/publishDiagnostics'] = function(err, result, ctx)
              if not result then
                return
              end
              result.diagnostics = vim.tbl_filter(function(d)
                return d.code ~= 6133 -- Ignore "variable is declared but never used" error
              end, result.diagnostics)
              require('ts-error-translator').translate_diagnostics(err, result, ctx)
              return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
            end,
          },
        },
        vue_ls = {
          -- Workaround until this PR is merged https://github.com/mason-org/mason-lspconfig.nvim/issues/587
          init_options = {
            typescript = {
              tsdk = '',
            },
          },
        },
        eslint = {
          on_attach = function(client, bufnr)
            if base_on_attach then
              base_on_attach(client, bufnr)
            end
            -- Automatically run eslint --fix on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'LspEslintFixAll',
            })
          end,
        },
        pyright = {},
        ruff = {
          init_options = {
            settings = {
              configuration = '~/.config/ruff/pyproject.toml',
            },
          },
        },
        yamlls = {},
        helm_ls = {
          settings = {
            ['helm-ls'] = {
              yamlls = {
                path = 'yaml-language-server',
              },
            },
          },
        },
      }

      for server_name, opts in pairs(servers) do
        vim.lsp.enable(server_name)
        opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
        vim.lsp.config(server_name, opts)
      end

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        automatic_installation = false,
      }
    end,
  },
  {
    'towolf/vim-helm',
    ft = 'helm',
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    config = function()
      require('ts-error-translator').setup {}
    end,
  },
}
