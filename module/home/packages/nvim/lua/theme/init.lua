local M = {}
local cache = vim.g.themecache

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
    local file, err = io.open(cache .. filename, 'wb')

    if not file or err then
        vim.notify('Error writing ' .. file .. ':\n' .. err, vim.log.levels.ERROR)
        return
    end

    file:write(loadstring(lines)())
    file:close()

    -- Expected output: compile highlight commands into bytecode using `string.dump`
end

local compile = function(groups)
    if not vim.uv.fs_stat(cache) then
        vim.fn.mkdir(cache, 'p')
    end

    strToCache(vimrc.theme.name, tblToStr(groups))
end

---@param groups table[table] Highlight table
local fallback = function(groups)
    for k, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, k, opts)
    end
end

---@param scheme table[table] colorscheme with base0X to base1X
M.create = function(scheme)
    local file = cache .. vimrc.theme.name
    local exist, load = pcall(require, 'theme.group')

    if not exist then
        vim.notify("Directory 'theme/group' not found ...", vim.log.levels.WARN)
        return
    end

    local groups = load(scheme)
    compile(groups)

    local ok, _ = pcall(dofile, file)

    if not ok then
        vim.notify('Unable to load cache. Falling back to manual load ...', vim.log.levels.WARN)
        fallback(groups)
    end
end

return M
