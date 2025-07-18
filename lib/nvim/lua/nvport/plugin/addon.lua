return {
    { -- Fuzzy finder
        'ibhagwan/fzf-lua',
        dependencies = 'echasnovski/mini.icons',
        -- keys = keymap.fzf_lua,
        opts = {},
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(items, opts, on_choice)
                local ui_select = require 'fzf-lua.providers.ui_select'

                -- Register the fzf-lua picker the first time we call select.
                if not ui_select.is_registered() then
                    ui_select.register(function(ui_opts)
                        if ui_opts.kind == 'luasnip' then
                            ui_opts.prompt = 'Snippet choice: '
                            ui_opts.winopts = {
                                relative = 'cursor',
                                height = 0.35,
                                width = 0.3,
                            }
                        elseif ui_opts.kind == 'color_presentation' then
                            ui_opts.winopts = {
                                relative = 'cursor',
                                height = 0.35,
                                width = 0.3,
                            }
                        else
                            ui_opts.winopts = { height = 0.5, width = 0.4 }
                        end

                        -- Use the kind (if available) to set the previewer's title.
                        if ui_opts.kind then
                            ui_opts.winopts.title = string.format(' %s ', ui_opts.kind)
                        end

                        return ui_opts
                    end)
                end
                -- Don't show the picker if there's nothing to pick.
                if #items > 0 then
                    return vim.ui.select(items, opts, on_choice)
                end
            end
        end,
    },

    { -- Alternative file explorer
        'mikavilpas/yazi.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        -- keys = keymap.yazi,
        opts = {
            open_for_directories = true,
            floating_window_scaling_factor = 0.8,
            yazi_floating_window_border = 'none',
        },
    },

    { -- Global search and replace
        'MagicDuck/grug-far.nvim',
        cmd = 'GrugFar',
        opts = { headerMaxWidth = 80 },
    },

    { -- Additional utilities for yanky
        'gbprod/yanky.nvim',
        event = 'VeryLazy',
        opts = {
            ring = { history_length = 20 },
            highlight = { timer = 250 },
        },
        -- keys = keymap.yanky,
    },

    { -- Around/Inside operations
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
                    g = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line '$',
                            col = math.max(vim.fn.getline('$'):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
                },
                silent = true,
                search_method = 'cover',
                mappings = {
                    around_next = '',
                    inside_next = '',
                    around_last = '',
                    inside_last = '',
                },
            }
        end,
    },

    { -- Highlight colors
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
    },

    { -- Autopairs
        'echasnovski/mini.pairs',
        version = false,
        event = 'InsertEnter',
        opts = {},
    },

    { -- Surround text with choice
        'echasnovski/mini.surround',
        version = false,
        opts = {},
    },
}
