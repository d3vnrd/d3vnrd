if vim.loader then
    vim.loader.enable()
end

vim.g.base46_cache = vim.fn.stdpath 'data' .. '/base46/'
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Boostrap plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath,
    }
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

-- Put lazy into the runtimepath(rtp)
vim.opt.rtp:prepend(lazypath)

-- Setup and install plugins
require('lazy').setup {
    spec = {
        {
            dir = '~/project/nvport',
            lazy = false,
            prioity = 1000,
            import = 'nvport.plugin',
        },

        { import = 'plugin' },
    },
    ui = { border = 'none' },
    change_detection = { notify = false },
    rocks = { enabled = false },
}
