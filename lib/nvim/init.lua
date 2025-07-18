vim.g.base46_cache = vim.fn.stdpath 'data' .. '/base46/'
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- bootstrap plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local repo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', repo, '--branch=stable', lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- setup and install plugins
require('lazy').setup('nvport.plugin', {
    change_detection = { notify = false },
    rocks = { enabled = false },
})

require('nvport').setup {}
