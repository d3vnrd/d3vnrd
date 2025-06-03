-- Colorscheme (#colorscheme)
return {
    'rebelot/kanagawa.nvim',
    -- enable = true,
    priority = 1000,
    init = function()
        vim.cmd.colorscheme 'kanagawa'
    end,
    opts = {
        colors = {
            theme = { all = { ui = { bg_gutter = 'none' } } },
        },
        transparent = true,
        overrides = function(colors)
            local theme = colors.theme
            local palette = colors.palette

            return {
                -- Default setting for floating window
                NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                NormalFloat = { bg = 'none' },
                FloatBorder = { bg = 'none' },
                FloatTitle = { bg = 'none' },

                -- Completion menu
                Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_m3 },
                PmenuSel = { fg = 'none', bg = theme.ui.bg_p2 },
                PmenuSbar = { bg = theme.ui.bg_m1 },
                PmenuThumb = { bg = theme.ui.bg_p2 },

                -- Blink completion menu
                BlinkCmpMenu = { bg = 'none' },
                BlinkCmpMenuBorder = { fg = theme.ui.fg_dim, bg = 'none' },

                -- Default statusline
                StatusLine = { bg = 'none' },
                StatusLineNC = { bg = 'none' },

                -- Cmdline
                MsgArea = { bg = 'none' },
                MsgSeparator = { bg = 'none', fg = theme.ui.bg_m3 },
                MoreMsg = { bold = true },

                -- Horizontal separator (custom)
                HorSplit = { bg = 'none', fg = theme.ui.bg_m3, strikethrough = true },
            }
        end,
    },

    -- {
    --     'projekt0n/github-nvim-theme',
    --     enable = false,
    --     name = 'github-theme',
    --     priority = 1000,
    --     init = function()
    --         vim.cmd.colorscheme 'github_dark'
    --     end,
    --     opts = {
    --         options = {
    --             transparent = true,
    --         },
    --     },
    -- },
}
