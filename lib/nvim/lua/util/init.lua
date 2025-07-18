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
}

-- Setup function --
M.setup = function(opts)
    M.vimrc = vim.tbl_deep_extend('force', M.vimrc, opts or {})

    vim.api.nvim_create_user_command('checkcall', function()
        vim.cmd [[Lazy! load all]]
        vim.cmd [[checkhealth]]
    end, { desc = 'Load all plugins and run :checkhealth' })
end

return M
