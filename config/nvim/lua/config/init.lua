if vim.loader then
    vim.loader.enable()
end

-- See `:help vim.opt` and `:help option-list` for more information
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.have_nerd_font = true

local options = {
    -- Enable auto indentation
    autoindent = true,

    -- Enable break indent
    breakindent = true,

    -- Confirmation for unsaved file
    confirm = true,

    -- Show which line the cursor is on
    cursorline = true,

    -- Encoding
    encoding = 'utf-8',
    fileencoding = 'utf-8',

    -- Make relative number default
    relativenumber = true,

    -- Enable termguicolors
    termguicolors = true,

    -- Make mouse movement smoother
    smoothscroll = true,

    -- Don't show edit mode
    showmode = true,

    -- Make cursor a single block
    guicursor = '',

    -- Keep signcolumn on by default
    signcolumn = 'yes',

    -- Mouse options: "a" all, "n" normal, "i" insert, "v" visual
    mouse = 'n',

    -- Configure how new splits should be opened
    splitright = true,
    splitbelow = true,

    -- Configure search behaviours
    ignorecase = true,
    smartcase = true,
    incsearch = true,
    hlsearch = false,

    -- Save undo history to undodir
    swapfile = false,
    backup = false,
    undofile = true,

    -- Configure tab indent
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    -- Configure characters display in the editor
    list = true,
    listchars = { tab = '| ', trail = '·', nbsp = '␣' },
    fillchars = { msgsep = '─' },

    -- Configure how completion menus behave
    completeopt = 'menuone,noselect,noinsert',
    pumheight = 15,

    -- Preview substitutions live, as w type
    inccommand = 'split',

    -- Hide tabline
    showtabline = 0,

    -- Allow only n command line
    cmdheight = 1,

    -- Decrease update time
    updatetime = 300,

    -- Decrease mapped sequence wait time
    timeoutlen = 500,
    ttimeoutlen = 10,

    -- Default wrap option
    wrap = false,
    linebreak = true,
    colorcolumn = '80',

    -- Default float border
    winborder = 'rounded',

    -- Stay center
    scrolloff = 20,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Short messages
vim.opt.shortmess:append {
    w = true,
    s = true,
}

-- Sync clipboard between OS and Neovim
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Disable unused default plugin
local disabled_built_ins = {
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'gzip',
    'zip',
    'zipPlugin',
    'tar',
    'tarPlugin',
    'getscript',
    'getscriptPlugin',
    'vimball',
    'vimballPlugin',
    '2html_plugin',
    'logipat',
    'rrhelper',
    'spellfile_plugin',
    'matchit',
    'python3_provider',
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g['loaded_' .. plugin] = 1
end

-- Import other important modules
local configs = vim.api.nvim_get_runtime_file('lua/config/*.lua', true)
for _, path in ipairs(configs) do
    local file = vim.fn.fnamemodify(path, ':t:r')
    if file ~= 'init' then
        pcall(require('config.' .. file))
    end
end
