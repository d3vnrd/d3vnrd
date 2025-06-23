-- Syntax highlighting
return {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate', -- Command to run when treesitter is installed or updated
    opts = function()
        local parser = {
            -- List of parsers to install
            'c',
            'lua',
            'vim',
            'vimdoc',
            'query',
            'markdown',
            'markdown_inline',
            'yaml',
            'python',
            'latex',
            'html',
            'regex',
        }
        return {
            auto_install = false,
            ensure_installed = parser,
            highlight = {
                enable = true,

                -- disable on large file
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,

                additional_vim_regex_highlighting = false,
            },

            indent = { enable = true, disable = { 'yaml' } },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'gnn',
                    node_incremental = 'grn',
                    scope_incremental = 'grc',
                    node_decremental = 'grm',
                },
            },
        }
    end,
}
