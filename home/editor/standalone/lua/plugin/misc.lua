return {
    { -- Auto detect indentation (#guess-indent)
        'nmac427/guess-indent.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {},
    }, --(#guess-indent)

    { -- Better copy/paste (#yanky)
        'gbprod/yanky.nvim',
        opts = {
            ring = { history_length = 20 },
            highlight = { timer = 250 },
        },
        keys = {
            { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
            { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
            { '=p', '<Plug>(YankyPutAfterLinewise)', desc = 'Put yanked text in line below' },
            { '=P', '<Plug>(YankyPutBeforeLinewise)', desc = 'Put yanked text in line above' },
            { '[y', '<Plug>(YankyCycleForward)', desc = 'Cycle forward through yank history' },
            { ']y', '<Plug>(YankyCycleBackward)', desc = 'Cycle backward through yank history' },
            { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yanky yank' },
        },
    }, --(#yanky)

    { -- Search/replace in multiple files (#grug-far)
        'MagicDuck/grug-far.nvim',
        opts = { headerMaxWidth = 80 },
        cmd = 'GrugFar',
        keys = {
            {
                '<leader>sr',
                function()
                    local grug = require 'grug-far'
                    local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
                    grug.open {
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                        },
                    }
                end,
                mode = { 'n', 'v' },
                desc = 'Search and Replace',
            },
        },
    }, --(#grug-far)

    { -- File explorer (#yazi)
        'mikavilpas/yazi.nvim',
        event = 'VeryLazy',
        dependencies = {
            'folke/snacks.nvim',
            'nvim-lua/plenary.nvim',
        },

        -- stylua: ignore
        keys = {
            { '-', mode = { 'n', 'v' }, '<cmd>Yazi<cr>', desc = 'Open yazi at the current file', },
            { '<leader>e', '<cmd>Yazi cwd<cr>', desc = "Open the file manager in nvim's working directory", },
        },

        opts = {
            open_for_directories = true,
            floating_window_scaling_factor = 1,
            yazi_floating_window_border = 'none',
        },
    }, --(#yazi)

    { -- Quarto support (#quarto-nvim)
        'quarto-dev/quarto-nvim',
        ft = { 'quarto', 'markdown', 'rmarkdown' },

        dependencies = {
            { -- LSP features and a code completion source for embedded code (#otter)
                'jmbuhr/otter.nvim',
                dependencies = { 'nvim-treesitter/nvim-treesitter' },
                opts = {},
            },

            { -- Markdown table generator (#vim-table-mode)
                'dhruvasagar/vim-table-mode',
                cmd = 'TableModeToggle',
                config = function()
                    vim.g.table_mode_corner = '|'
                end,
            },
        },

        opts = {
            debug = false,
            closePreviewOnExit = false,
            lspFeatures = {
                enabled = true,
                chunks = 'curly',
            },
            codeRunner = { enabled = false },
        },
    }, --(#quarto-nvim)

    { -- Auto closing tags for HTML and JSX
        'windwp/nvim-ts-autotag',
        event = 'InsertEnter',
        opts = {},
    },
}
