local M = {}

-- Default config --
M.portrc = {
    support = {
        'bash',
        'lua',
        'luadoc',
        'printf',
        'vim',
        'vimdoc',
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
    M.portrc = vim.tbl_deep_extend('force', M.portrc, opts or {})

    ---@param path string
    local safe_call = function(path)
        local ok, module = pcall(require, path)
        if ok then
            return module
        else
            vim.notify(string.format('Unable to reach: %s', path), vim.log.levels.ERROR)
        end
    end

    local lazy_autocmds = vim.fn.argc(-1) == 0
    if not lazy_autocmds then
        safe_call 'command'
    end

    -- always load options first
    safe_call 'option'

    -- enable other modules on demand
    vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'VeryLazy',
        callback = function()
            if lazy_autocmds then
                safe_call 'command'
            end

            safe_call 'server'
            safe_call('keymap').builtin()
        end,
    })
end

return M
