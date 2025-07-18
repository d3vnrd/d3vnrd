local M = {}

M.dependencies = {
    'nvim-lua/plenary.nvim',

    { -- Snippet engine
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
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

    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
}

-- Syntax highlighting and text objects
M.treesitter = {
    'nvim-treesitter/nvim-treesitter',
    layz = false,
    version = false,
    build = ':TSUpdate',
    opts = {
        ensure_installed = require('nvport').portrc.support,

        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = false,

            -- Disable on large file
            disable = function(_, buf)
                local max_filesize = 100 * 1024 -- 100Kb
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },

        indent = { enable = true, disable = { 'yaml' } },
    },
}

-- Auto completion engine
M.blink = {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '*',
    dependencies = {
        'LuaSnip',
        'folke/lazydev.nvim',
    },
    opts = function()
        -- Extend Neovim's client capabilities with the completion ones
        vim.lsp.config('*', {
            capabilities = require('blink-cmp').get_lsp_capabilities(nil, true),
        })
        return {
            snippets = { preset = 'luasnip' },
            keymap = { preset = 'default' },

            cmdline = { enabled = false },
            signature = { enabled = true },

            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                ghost_text = { enabled = true },
            },

            sources = {
                -- Disable some sources in comments and strings
                default = function()
                    local sources = { 'lsp', 'buffer' }
                    local ok, node = pcall(vim.treesitter.get_node)

                    if ok and node then
                        if
                            not vim.tbl_contains({
                                'comment',
                                'line_comment',
                                'block_comment',
                            }, node:type())
                        then
                            table.insert(sources, 'path')
                        end
                        if node:type() ~= 'string' then
                            table.insert(sources, 'snippets')
                        end
                    end

                    return sources
                end,

                providers = {
                    lazydev = {
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                },

                per_filetype = {
                    lua = { inherit_defaults = true, 'lazydev' },
                },
            },
        }
    end,
}

-- Copilot integration
M.copilot = {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
        require('copilot').setup {}
    end,
}

M.conform = { -- File formatting
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
        notify_on_error = false,

        format_on_save = function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                }
            end
        end,

        formatters = {
            dprint = {
                command = 'dprint',
                args = {
                    'fmt',
                    '--stdin',
                    '$FILENAME',
                    '--config',
                    vim.api.nvim_get_runtime_file('.dprint.jsonc', true)[1],
                },
                stdin = true,
            },
        },

        formatters_by_ft = {
            lua = { 'stylua' },
            nix = { 'alejandra' },
            markdown = { 'dprint' },
            python = { 'dprint', 'isort', 'black', stop_after_first = true },

            -- For filetypes without a formatter
            ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
    },
}

return vim.iter(M)
    :map(function(_, v)
        return v
    end)
    :totable()
