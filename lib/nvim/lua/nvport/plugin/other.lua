return {
    "nvim-lua/plenary.nvim",

    { -- Snippet engine
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
            return "make install_jsregexp"
        end)(),
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = {},
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
