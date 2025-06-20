vim.api.nvim_create_user_command('ToggleWrap', function()
    vim.wo.wrap = not vim.wo.wrap
    vim.notify('Wrap ' .. (vim.wo.wrap and 'enabled' or 'disabled'), vim.log.levels.INFO)
end, { desc = 'Toggle wrap in current buffer', nargs = 0 })

---@param desc string
local augroup = function(desc)
    return vim.api.nvim_create_augroup('user/' .. desc, { clear = true })
end

-- source: unknown
vim.api.nvim_create_autocmd('BufHidden', {
    group = augroup 'delete_no_name',
    desc = 'Delete [No Name] buffers',
    callback = function(args)
        if args.file == '' and vim.bo[args.buf].buftype == '' and not vim.bo[args.buf].modified then
            vim.schedule(function()
                pcall(vim.api.nvim_buf_delete, args.buf, {})
            end)
        end
    end,
})

-- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua#L29
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'close_with_q',
    desc = 'Close with <q>',
    pattern = {
        'git',
        'help',
        'man',
        'qf',
        'scratch',
        'grug-far',
        'terminal',
    },
    callback = function(args)
        vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
    end,
})

-- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua#L44
vim.api.nvim_create_autocmd('CmdwinEnter', {
    group = augroup 'execute_cmd_and_stay',
    desc = 'Execute command and stay in the command-line window',
    callback = function(args)
        vim.keymap.set({ 'n', 'i' }, '<S-CR>', '<cr>q:', { buffer = args.buf })
    end,
})

-- source: unknown
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup 'last_location',
    desc = 'Go to the last location when opening a buffer',
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd 'normal! g`"zz'
        end
    end,
})

-- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua#L118C1-L125C3
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup 'hl_on_yank',
    desc = 'Highlight on yank',
    callback = function()
        -- Setting a priority higher than the LSP references one.
        vim.hl.on_yank { higroup = 'Visual', priority = 250 }
    end,
})

-- source: https://github.com/tjdevries/config.nvim/blob/master/plugin/terminal.lua
vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', {}),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.scrolloff = 0

        vim.bo.filetype = 'terminal'
    end,
})
