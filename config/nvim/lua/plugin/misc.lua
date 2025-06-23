return {
    { -- Support Neovim APIs (#lazydev)
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    }, -- (#lazydev)

    { -- Autopairs (#minipairs)
        'echasnovski/mini.pairs',
        version = false,
        event = 'InsertEnter',
        opts = {},
    }, --(#minipairs)

    { -- Better text objects navigation (#miniai)
        'echasnovski/mini.ai',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
        opts = function()
            local miniai = require 'mini.ai'

            return {
                n_lines = 300,
                custom_textobjects = {
                    f = miniai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
                    -- Whole buffer.
                    g = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line '$',
                            col = math.max(vim.fn.getline('$'):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
                },
                -- Disable error feedback.
                silent = true,
                -- Don't use the previous or next text object.
                search_method = 'cover',
                mappings = {
                    -- Disable next/last variants.
                    around_next = '',
                    inside_next = '',
                    around_last = '',
                    inside_last = '',
                },
            }
        end,
    }, --(#miniai)

    { -- Hightlight pattern (#minihipatterns)
        'echasnovski/mini.hipatterns',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        opts = function()
            local hipatterns = require 'mini.hipatterns'
            return {
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }
        end,
    }, --(#minihipatterns)

    { -- Add-on surround actions (#minisurround)
        'echasnovski/mini.surround',
        version = false,
        opts = {},
    }, --(#minisurround)

    { -- Auto detect indentation (#guess-indent)
        'nmac427/guess-indent.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {},
    }, --(#guess-indent)
}
