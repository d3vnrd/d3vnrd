local methods = vim.lsp.protocol.Methods

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
    -- Keymap
    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    map('[d', function()
        vim.diagnostic.jump { count = -1 }
    end, 'Previous diagnostic')
    map(']d', function()
        vim.diagnostic.jump { count = 1 }
    end, 'Next diagnostic')
    map('[e', function()
        vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
    end, 'Previous error')
    map(']e', function()
        vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
    end, 'Next error')

    -- Features: Highlight word under cursor
    -- source: https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/lspconfig.lua#L125
    if client:supports_method(methods.textDocument_documentHighlight, bufnr) then
        local highlight_augroup = vim.api.nvim_create_augroup('user/lsp_highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('user/lsp_detach', { clear = true }),
            callback = function(_args)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = _args.buf }
            end,
        })
    end

    -- Features: Adding inlay-hints command if supported
    -- (remember to enable feature in server config)
    -- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/commands.lua#L6C1-L12C49
    if client:supports_method(methods.textDocument_inlayHint, bufnr) then
        vim.api.nvim_create_user_command('LspInlayHints', function()
            local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
            vim.lsp.inlay_hint.enable(not enabled)

            vim.notify(string.format('%s inlay-hints', enabled and 'Disable' or 'Enable'), vim.log.levels.INFO)
        end, { desc = 'Toggle inlay hints', nargs = 0 })
    end
end

return {
    'neovim/nvim-lspconfig',
    config = function()
        -- Define the diagnostic signs.
        -- See :help vim.diagnostic.Opts for more details
        -- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua#L146
        local dicons = require('icon').diagnostics
        for severity, icon in pairs(dicons) do
            local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
            vim.fn.sign_define(hl, { text = icon, texthl = hl })
        end

        vim.diagnostic.config {
            virtual_text = {
                prefix = '',
                spacing = 2,
                format = function(diagnostic)
                    -- Use shorter, nicer names for some sources:
                    local special_sources = {
                        ['Lua Diagnostics.'] = 'lua',
                        ['Lua Syntax Check.'] = 'lua',
                    }

                    local message = dicons[vim.diagnostic.severity[diagnostic.severity]]
                    if diagnostic.source then
                        message = string.format('%s %s', message, special_sources[diagnostic.source] or diagnostic.source)
                    end
                    if diagnostic.code then
                        message = string.format('%s[%s]', message, diagnostic.code)
                    end

                    return message .. ' '
                end,
            },
            float = {
                border = 'rounded',
                source = 'if_many',
                -- Show severity icons as prefixes.
                prefix = function(diag)
                    local level = vim.diagnostic.severity[diag.severity]
                    local prefix = string.format(' %s ', dicons[level])
                    return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
                end,
            },

            -- Disable signs in the gutter.
            signs = false,
        }

        -- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
        local show_handler = vim.diagnostic.handlers.virtual_text.show
        assert(show_handler)
        local hide_handler = vim.diagnostic.handlers.virtual_text.hide
        vim.diagnostic.handlers.virtual_text = {
            show = function(ns, bufnr, diagnostics, opts)
                table.sort(diagnostics, function(diag1, diag2)
                    return diag1.severity > diag2.severity
                end)
                return show_handler(ns, bufnr, diagnostics, opts)
            end,
            hide = hide_handler,
        }

        local hover = vim.lsp.buf.hover
        vim.lsp.buf.hover = function()
            ---@diagnostic disable-next-line: redundant-parameter
            return hover {
                max_height = math.floor(vim.o.lines * 0.5),
                max_width = math.floor(vim.o.columns * 0.4),
            }
        end

        local signature_help = vim.lsp.buf.signature_help
        vim.lsp.buf.signature_help = function()
            ---@diagnostic disable-next-line: redundant-parameter
            return signature_help {
                max_height = math.floor(vim.o.lines * 0.5),
                max_width = math.floor(vim.o.columns * 0.4),
            }
        end

        -- Update features when registering dynamic capabilities
        -- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua#L216
        local register_capability = vim.lsp.handlers[methods.client_registerCapability]
        vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            if not client then
                return
            end

            on_attach(client, vim.api.nvim_get_current_buf())

            return register_capability(err, res, ctx)
        end

        -- Lsp server configs (#server)
        local lsp_servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = { callSnippet = 'Replace' },
                        format = { enable = false },
                        hint = {
                            enable = true,
                            arrayIndex = 'Disable',
                        },
                        runtime = {
                            version = 'LuaJIT',
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                '${3rd}/luv/library',
                            },
                        },
                    },
                },
            },

            pyright = {
                capabilities = function()
                    local capabilities = vim.lsp.config.pyright.capabilities()

                    if capabilities.workspace == nil then
                        capabilities.workspace = {}
                        capabilities.workspace.didChangeWatchedFiles = {}
                    end
                    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

                    return capabilities
                end,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = 'workspace',
                        },
                    },
                },
                root_dir = function(fname)
                    return require('lspconfig.util').root_pattern('.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt')(fname)
                end,
            },

            marksman = {
                filetypes = { 'markdown', 'markdown.mdx', 'quarto' },
                root_dir = require('lspconfig.util').root_pattern('.git', '.marksman.toml', '_quarto.yml'),
            },

            nixd = {},
            -- dprint = {},
            -- harper_ls = {},
            html = {},
        }

        -- Merging each user setting with default server setting from lspconfig
        for k, v in pairs(lsp_servers) do
            vim.lsp.config(k, v)
        end

        -- Lsp on-attach caller
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('user/lsp_attach', { clear = true }),
            callback = function(args)
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                if not client then
                    return
                end

                on_attach(client, args.buf)
            end,
        })

        -- Enable support servers in pre-defined server list
        vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
            once = true, -- ensure command runs only once, then automatically removed
            callback = function()
                vim.lsp.enable(vim.tbl_keys(lsp_servers))
            end,
        })
    end,
}
