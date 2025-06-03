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
            { '<leader>sh', picker 'help', desc = 'Help Pages' },
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

M.miniclue = function()
    local clue = require 'mini.clue'
    return {
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'x', keys = '<Leader>' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },

            -- Marks
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },

            -- Registers
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = 'n', keys = 'z' },
            { mode = 'x', keys = 'z' },
        },

        clues = {
            clue.gen_clues.builtin_completion(),
            clue.gen_clues.g(),
            clue.gen_clues.marks(),
            clue.gen_clues.registers(),
            clue.gen_clues.windows(),
            clue.gen_clues.z(),
        },

        window = {
            config = {
                width = vim.api.nvim_win_get_width(0),
                height = 5,
                title_pos = 'center',
                border = { '', '─', '', '', '', '', '', '' },
            },
            delay = 500,
        },
    }
end

M.miniai = function()
    local miniai = require 'mini.ai'

    return {
        n_lines = 300,
        custom_textobjects = {
            f = miniai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
            -- Whole buffer.
            g = function()
                local from = { line = 1, col = 1 }
                local to = {
                    line = vim.fn.line '$',
                    col = math.max(vim.fn.getline('$'):len(), 1),
                }
                return { from = from, to = to }
            end,
        },
        -- Disable error feedback.
        silent = true,
        -- Don't use the previous or next text object.
        search_method = 'cover',
        mappings = {
            -- Disable next/last variants.
            around_next = '',
            inside_next = '',
            around_last = '',
            inside_last = '',
        },
    }
end

M.quarto = function()
    return {}
end

return M
