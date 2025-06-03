local helper = require 'plugin.addon.help'

return {
    { -- Small Qol plugins (#snacks)
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        keys = helper.snacks.keys(),
        opts = helper.snacks.setup(),
    }, --(#snacks)

    { -- Keymap references (#miniclue)
        'echasnovski/mini.clue',
        event = 'VeryLazy',
        version = false,
        opts = function()
            return helper.miniclue()
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
            return helper.miniai()
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

    -- { -- Add-on surround actions (#minisurround)
    --     'echasnovski/mini.surround',
    --     version = false,
    --     opts = {},
    -- }, --(#minisurround)

    { -- Auto detect indentation (#guess-indent)
        'nmac427/guess-indent.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {},
    }, --(#guess-indent)

    -- { -- Better copy/paste (#yanky)
    --     'gbprod/yanky.nvim',
    --     opts = {
    --         ring = { history_length = 20 },
    --         highlight = { timer = 250 },
    --     },
    --     keys = {
    --         { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
    --         { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
    --         { '=p', '<Plug>(YankyPutAfterLinewise)', desc = 'Put yanked text in line below' },
    --         { '=P', '<Plug>(YankyPutBeforeLinewise)', desc = 'Put yanked text in line above' },
    --         { '[y', '<Plug>(YankyCycleForward)', desc = 'Cycle forward through yank history' },
    --         { ']y', '<Plug>(YankyCycleBackward)', desc = 'Cycle backward through yank history' },
    --         { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yanky yank' },
    --     },
    -- }, --(#yanky)

    -- { -- Search/replace in multiple files (#grug-far)
    --     'MagicDuck/grug-far.nvim',
    --     opts = { headerMaxWidth = 80 },
    --     cmd = 'GrugFar',
    --     keys = {
    --         {
    --             '<leader>sr',
    --             function()
    --                 local grug = require 'grug-far'
    --                 local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
    --                 grug.open {
    --                     transient = true,
    --                     prefills = {
    --                         filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    --                     },
    --                 }
    --             end,
    --             mode = { 'n', 'v' },
    --             desc = 'Search and Replace',
    --         },
    --     },
    -- }, --(#grug-far)

    { -- File explorer (#yazi)
        'mikavilpas/yazi.nvim',
        event = 'VeryLazy',
        dependencies = {
            'folke/snacks.nvim',
            'nvim-lua/plenary.nvim',
        },

        keys = {
            { '-', mode = { 'n', 'v' }, '<cmd>Yazi<cr>', desc = 'Open yazi at the current file' },
            { '<leader>e', '<cmd>Yazi cwd<cr>', desc = "Open the file manager in nvim's working directory" },
        },

        opts = {
            open_for_directories = true,
            floating_window_scaling_factor = 0.8,
            yazi_floating_window_border = 'rounded',
        },
    }, --(#yazi)
}
