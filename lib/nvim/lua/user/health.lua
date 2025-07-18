local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local check_version = function()
    local ver = vim.version()
    if not vim.version.ge then
        error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly version", tostring(ver)))
        return
    end

    if vim.version.ge(ver, '0.11.0') then
        ok(string.format("Neovim version is: '%s'", tostring(ver)))
    else
        error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly version", tostring(ver)))
    end
end
local check_exeternal_reqs = function()
    for _, exe in ipairs {
        'git',
        'make',
        'unzip',
        'rg',
        'yazi',
    } do
        local is_executable = vim.fn.executable(exe) == 1
        if is_executable then
            ok(string.format("Found executable: '%s'", exe))
        else
            warn(string.format("Could not find executable: '%s'", exe))
        end
    end

    return true
end

return {
    check = function()
        start 'nvport'
        vim.health.info "NOTE: Not every warning is a 'must-fix' in ':checkhealth'"

        local uv = vim.uv or vim.loop
        vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

        check_version()
        check_exeternal_reqs()
    end,
}
