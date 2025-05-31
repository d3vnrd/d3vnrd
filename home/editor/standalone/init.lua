vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
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

-- Setup lazy.nvim and install plugins
require('lazy').setup {
    spec = {
        { -- Configure Lua LSP to recognize completion, annotations, and signatures of Neovim APIs
            'folke/lazydev.nvim',
            ft = 'lua',
            opts = {
                library = {
                    -- Load luvit types when the `vim.uv` word is found
                    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                },
            },
        },

        { import = 'lsp' }, -- lsp config
        { import = 'color' }, -- colorscheme
        { import = 'plugin' }, -- other optional plugins
    },

    -- Lazy options
    ui = { border = 'rounded' },
    change_detection = { notify = false },
    rocks = { enabled = false },
}
