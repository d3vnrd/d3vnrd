local M = {}

-- Default config --
M.vimrc = {
    support = {
        'bash',
        'lua',
        'luadoc',
        'printf',
        'vim',
        'vimdoc',
        'nix',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'json',
    },

    theme = {
        transparent = false,
    },
}

-- Setup function --
M.setup = function(opts)
    M.vimrc = vim.tbl_deep_extend('force', M.vimrc, opts or {})
end

return M
