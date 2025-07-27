return function(scheme)
    local result = {}

    -- Get all highlight groups and merge them into a single table
    vim.iter(vim.api.nvim_get_runtime_file('lua/theme/group/*.lua', true)):each(function(file)
        local name = vim.fn.fnamemodify(file, ':t:r')
        if name ~= 'init' then
            local ok, group = pcall(require, 'theme.group.' .. name)
            if ok and type(group) == 'function' then
                local hl = group(scheme)
                if type(hl) == 'table' then
                    vim.tbl_deep_extend('error', result, hl)
                end
            else
                vim.notify('Failed to load highlight group: ' .. name, vim.log.levels.WARN)
            end
        end
    end)

    return result
end
