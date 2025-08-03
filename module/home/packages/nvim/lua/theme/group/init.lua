return function(scheme)
    local M = {}

    for _, file in ipairs(vim.api.nvim_get_runtime_file('lua/theme/group/*.lua', true)) do
        local name = vim.fn.fnamemodify(file, ':t:r')
        if name ~= 'init' then
            local ok, load = pcall(require, 'theme.group.' .. name)
            if ok and type(load) == 'function' then
                local hl = load(scheme)
                if type(hl) == 'table' then
                    M = vim.tbl_deep_extend('error', M, hl)
                end
            else
                vim.notify('Failed to load highlight group: ' .. name, vim.log.levels.WARN)
            end
        end
    end

    return M
end
