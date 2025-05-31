if vim.loader then
    vim.loader.enable()
end

-- Enable nerd font support
vim.g.have_nerd_font = false

-- See `:help vim.opt` and `:help option-list` for more information
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
    updatetime = 50,

    -- Decrease mapped sequence wait time
    timeoutlen = 500,
    ttimeoutlen = 10,

    -- Default wrap option
    wrap = true,
    linebreak = true,

    -- Default float border
    winborder = 'rounded',

    -- Stay center
    scrolloff = 20,

    -- Screen vertical line
    colorcolumn = '100',
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Short messages
vim.opt.shortmess:append {
    w = true,
    s = true,
}

-- Disable unsused default plugin
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

-- Sync clipboard between OS and Neovim
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)
