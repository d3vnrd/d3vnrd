--- Bootstrap plugin manager ---
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local repo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        repo,
        '--branch=stable',
        lazypath,
    }
end

--- Add lazy into runtime path ---
vim.opt.rtp:prepend(lazypath)

--- Setup and install plugins ---
require('lazy').setup('plugin', {
    change_detection = { notify = false },
    rocks = { enabled = false },
})
