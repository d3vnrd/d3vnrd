-- Code auto completion (#cmp)
return {
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

        -- Quarto pandoc/markdown cross references
        'jmbuhr/cmp-pandoc-references',

        -- Latex symbols
        'erooke/blink-cmp-latex',
    },

    ---@module 'blink-cmp'
    ---@type blink.cmp.Config
    opts = {
        cmdline = { enabled = false },
        keymap = {
            ['<CR>'] = { 'accept', 'fallback' },
            ['<C-\\>'] = { 'hide', 'fallback' },
            ['<C-n>'] = { 'select_next', 'show' },
            ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
            ['<C-p>'] = { 'select_prev' },
            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        },
        appearance = {
            kind_icons = require('icon').symbol_kinds,
            nerd_font_variant = 'mono',
        },

        -- Cmp-appearance
        completion = {
            keyword = { range = 'prefix' },
            list = {
                selection = { preselect = false, auto_insert = false },
                max_items = 10,
            },
            menu = {
                auto_show = true,
                draw = {
                    columns = {
                        { 'label', 'label_description', gap = 1 },
                        { 'kind_icon', 'source_name', gap = 1 },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                treesitter_highlighting = true,
            },
            ghost_text = { enabled = true },
        },

        -- Sources
        sources = {
            default = function()
                local sources = { 'lsp', 'buffer' }
                local ok, node = pcall(vim.treesitter.get_node)

                if ok and node then
                    if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                        table.insert(sources, 'path')
                    end
                    if node:type() ~= 'string' then
                        table.insert(sources, 'snippets')
                    end
                end

                return sources
            end,

            per_filetype = {
                lua = { inherit_defaults = true, 'lazydev' },
                markdown = { inherit_defaults = true, 'latex' },
                quarto = { inherit_defaults = true, 'references', 'latex' },
            },

            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    score_offset = 100, -- top priority
                },
                references = {
                    name = 'pandoc_references',
                    module = 'cmp-pandoc-references.blink',
                    score_offset = 2,
                },
                latex = {
                    name = 'Latex',
                    module = 'blink-cmp-latex',
                    opts = { insert_command = true },
                },
            },
        },

        snippets = { preset = 'luasnip' },
        signature = { enabled = true },

        -- See :h blink-cmp-config-fuzzy for more information
        fuzzy = { implementation = 'prefer_rust_with_warning' },
    },

    config = function(_, opts)
        require('blink.cmp').setup(opts)

        -- Extend neovim's client capabilities with the completion ones
        vim.lsp.config('*', { capabilities = require('blink-cmp').get_lsp_capabilities(nil, true) })
    end,
}
