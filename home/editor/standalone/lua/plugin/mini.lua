return {
    { -- Keymap references (#miniclue)
        'echasnovski/mini.clue',
        event = { 'BufReadPost', 'BufNewFile' },
        version = false,
        opts = function()
            local clue = require 'mini.clue'
            return {
                triggers = {
                    -- Leader triggers
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },

                    -- Built-in completion
                    { mode = 'i', keys = '<C-x>' },

                    -- `g` key
                    { mode = 'n', keys = 'g' },
                    { mode = 'x', keys = 'g' },

                    -- Marks
                    { mode = 'n', keys = "'" },
                    { mode = 'n', keys = '`' },
                    { mode = 'x', keys = "'" },
                    { mode = 'x', keys = '`' },

                    -- Registers
                    { mode = 'n', keys = '"' },
                    { mode = 'x', keys = '"' },
                    { mode = 'i', keys = '<C-r>' },
                    { mode = 'c', keys = '<C-r>' },

                    -- Window commands
                    { mode = 'n', keys = '<C-w>' },

                    -- `z` key
                    { mode = 'n', keys = 'z' },
                    { mode = 'x', keys = 'z' },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    clue.gen_clues.builtin_completion(),
                    clue.gen_clues.g(),
                    clue.gen_clues.marks(),
                    clue.gen_clues.registers(),
                    clue.gen_clues.windows(),
                    clue.gen_clues.z(),
                },

                window = {
                    delay = 250,
                },
            }
        end,
    }, --(#miniclue)

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
        config = function()
            local hipatterns = require 'mini.hipatterns'
            hipatterns.setup {
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
}
