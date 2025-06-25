local M = {}
M.snacks = {
    setup = function()
        local enable = {
            'bufdelete',
            'git',
            'gitbrowse',
            'lazygit',
            'profiler',
            'quickfile',
            'animate',
        }

        local config = {}
        for _, v in ipairs(enable) do
            config[v] = { enabled = true }
        end

        config.picker = {
            ui_select = false,
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                    },
                },
            },
        }

        config.bigfile = {}

        config.styles = {
            lazygit = {
                width = 0,
                height = 0,
            },
        }

        return config
    end,

    keys = function()
        local picker = function(input, opts)
            opts = vim.inspect(opts or {}, { newline = '', indent = '' })
            return string.format('<cmd>lua Snacks.picker.%s(%s)<cr>', input, opts)
        end

        return {
            -- Common picker
            { '<leader><space>', picker 'smart', desc = 'Smart Find Files' },
            { '<leader>fb', picker 'buffers', desc = 'Buffers' },
            { '<leader>ff', picker 'files', desc = 'Find Files' },
            { '<leader>fn', picker('files', { cwd = vim.fn.stdpath 'config' }), desc = 'Find Config File' },
            { '<leader>fg', picker 'git_files', desc = 'Find Git Files' },
            { '<leader>fp', picker 'projects', desc = 'Projects' },

            -- Git
            { '<leader>gb', picker 'git_branches', desc = 'Git Branches' },
            { '<leader>gl', picker 'git_log', desc = 'Git Log' },
            { '<leader>gL', picker 'git_log_line', desc = 'Git Log Line' },
            { '<leader>gs', picker 'git_status', desc = 'Git Status' },
            { '<leader>gS', picker 'git_stash', desc = 'Git Stash' },
            { '<leader>gd', picker 'git_diff', desc = 'Git Diff (Hunks)' },
            { '<leader>gf', picker 'git_log_file', desc = 'Git Log File' },
            { '<leader>go', '<cmd>lua Snacks.lazygit.open()<cr>', desc = 'Open lazygit' },

            -- Grep
            { '<leader>sb', picker 'lines', desc = 'Buffer Lines' },
            { '<leader>sB', picker 'grep_buffers', desc = 'Grep Open Buffers' },
            { '<leader>sg', picker 'grep', desc = 'Grep' },
            { '<leader>sw', picker 'grep_word', desc = 'Visual selection or word', mode = { 'n', 'x' } },

            -- Search
            { '<leader>s"', picker 'registers', desc = 'Registers' }, -- good
            { '<leader>s/', picker 'search_history', desc = 'Search History' },
            -- { '<leader>sa', picker 'autocmds', desc = 'Autocmds' },
            { '<leader>sb', picker 'lines', desc = 'Buffer Lines' },
            { '<leader>sc', picker 'command_history', desc = 'Command History' },
            { '<leader>sC', picker 'commands', desc = 'Commands' },
            { '<leader>sd', picker 'diagnostics', desc = 'Diagnostics' },
            { '<leader>sD', picker 'diagnostics_buffer', desc = 'Buffer Diagnostics' },
            { '<leader>sh', picker 'helper', desc = 'Help Pages' },
            { '<leader>sH', picker 'highlights', desc = 'Highlights' },
            -- { '<leader>si', picker 'icons', desc = 'Icons' },
            -- { '<leader>sj', picker 'jumps', desc = 'Jumps' },
            -- { '<leader>sk', picker 'keymaps', desc = 'Keymaps' },
            { '<leader>sl', picker 'loclist', desc = 'Location List' },
            -- { '<leader>sm', picker 'marks', desc = 'Marks' },
            { '<leader>sM', picker 'man', desc = 'Man Pages' },
            { '<leader>sp', picker 'lazy', desc = 'Search for Plugin Spec' }, -- good
            { '<leader>sq', picker 'qflist', desc = 'Quickfix List' },
            { '<leader>sR', picker 'resume', desc = 'Resume' },
            { '<leader>su', picker 'undo', desc = 'Undo History' },
        }
    end,
}

-- Small Qol plugins
return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = M.snacks.keys(),
    opts = M.snacks.setup(),
}
