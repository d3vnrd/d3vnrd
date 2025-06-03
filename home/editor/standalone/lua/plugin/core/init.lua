-- Helper function to hide long config
local helper = require 'plugin.core.help'

return {
    { -- Configure Lua LSP to recognize completion, annotations, and signatures of Neovim APIs
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },

    { -- Language sever protocol (#lsp)
        'neovim/nvim-lspconfig',
        config = helper.lsp {
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
                    return require('lspconfig.util').root_pattern(
                        '.git',
                        'setup.py',
                        'setup.cfg',
                        'pyproject.toml',
                        'requirements.txt'
                    )(fname)
                end,
            },

            marksman = {},
            nixd = {},
            html = {},
        },
    },

    { -- Syntax hightlighting (#trs)
        'nvim-treesitter/nvim-treesitter',
        version = false,
        build = ':TSUpdate', -- command to run when treesitter is installed or updated
        opts = helper.trs {
            -- List of parsers to install
            'c',
            'lua',
            'vim',
            'vimdoc',
            'query',
            'markdown',
            'markdown_inline',
            'yaml',
            'python',
            'latex',
            'html',
        },
    },

    { -- Auto completion and suggestion (#cmp)
        'saghen/blink.cmp',
        event = 'InsertEnter',
        version = '*',
        dependencies = {
            { -- Snippets engine
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    -- Build step is needed for regex support in snippets.
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
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

            -- Quarto pandoc/markdown cross references
            'jmbuhr/cmp-pandoc-references',

            -- Latex symbols
            'erooke/blink-cmp-latex',
        },

        ---@module 'blink-cmp'
        ---@type blink.cmp.Config
        opts = helper.cmp(),

        config = function(_, opts)
            require('blink.cmp').setup(opts)

            -- Extend neovim's client capabilities with the completion ones
            vim.lsp.config('*', {
                capabilities = require('blink-cmp').get_lsp_capabilities(nil, true),
            })
        end,
    },

    { -- File formatting (#fmt)
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        cmd = 'ConformInfo',
        init = function()
            -- Use conform for gq
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        opts = helper.fmt {
            lua = { 'stylua' },
            nix = { 'alejandra' },
            python = { 'isort', 'black' },
            markdown = { 'prettier' },

            -- For filetypes without a formatter
            ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
    },

    { -- Code analysis (#lnt)
        'mfussenegger/nvim-lint',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            helper.lnt {
                -- <filetype> = { "<linter>" },
            }
        end,
    },

    { -- Debugger (#dap)
    },

    { -- AI integration (#copilot)
        -- 'zbirenbaum/copilot.lua',
        -- cmd = 'Copilot',
        -- event = 'InsertEnter',
        -- opts = {}
    },
}
