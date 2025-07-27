local M = {}
local cachePath = vim.g.base18_cache

---@param tbl table[table] Highlight table
local fallback = function(tbl)
    for group, opts in pairs(tbl) do
        if group ~= 'name' then
            vim.api.nvim_set_hl(0, group, opts)
        end
    end
end

---@param tbl table[table] Highlight table
local tblToStr = function(tbl)
    local result = ''

    for hlgroupName, v in pairs(tbl) do
        local hlname = "'" .. hlgroupName .. "',"
        local hlopts = ''

        for optName, optVal in pairs(v) do
            local valueInStr = ((type(optVal)) == 'boolean' or type(optVal) == 'number') and tostring(optVal)
                or '"' .. optVal .. '"'
            hlopts = hlopts .. optName .. '=' .. valueInStr .. ','
        end

        result = result .. 'vim.api.nvim_set_hl(0,' .. hlname .. '{' .. hlopts .. '})\n'
    end

    return result

    -- Expected output: convert highlight table into executable string
    -- { Normal = {fg = "...", bg = "..."} }
    -- into "vim.api.nvim_set_hl(0,'Normal',{fg="...",bg="...",})"
end

---@param filename string
---@param str string
local strToCache = function(filename, str)
    local lines = 'return string.dump(function()' .. str .. 'end, true)'
    local file, err = io.open(cachePath .. filename, 'wb')

    if not file or err then
        vim.notify('Error writing ' .. file .. ':\n' .. err, vim.log.levels.ERROR)
        return
    end

    file:write(loadstring(lines)())
    file:close()

    -- Expected output: compile highlight commands into bytecode using `string.dump`
end

local compile = function(tbl)
    if not vim.uv.fs_stat(cachePath) then
        vim.fn.mkdir(cachePath, 'p')
    end

    -- Expected output: compile all tables into cache file
    -- Opt 1: compile everyting in a single cache file
    -- Opt 2: compile into modular cache files for each hl_group

    -- Additional: support multiple themes by compile each theme into their own cache file
end

---@param tbl table[table[string]] Colorscheme table
M.setup = function(tbl)
    vim.cmd.highlight 'clear'
    if vim.fn.exists 'syntax_on' then
        vim.cmd.syntax 'reset'
    end

    vim.g.colors_name = tbl.name
    local hl_group = require 'theme.group'(tbl) -- return table of highlights according to theme
    local file = cachePath .. tbl.name

    if vim.fn.filereadable(file) == 0 then
        compile(hl_group) -- compile only when not existed
    end

    local ok, _ = pcall(dofile, file)
    if not ok then
        vim.notify('Failed to load: ' .. tbl.name .. '\n' .. '\nFalling back ...', vim.log.levels.ERROR)
        fallback(hl_group)
    end
end

return M
