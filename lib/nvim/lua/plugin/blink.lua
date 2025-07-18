return {
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
                ghost_text = { enabled = false },
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
