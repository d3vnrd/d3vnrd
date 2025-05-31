-- Check for code errors without actual running code (#lnt)
return {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        local lint = require 'lint'
        lint.linters_by_ft = {
            -- <filetype> = { "<linter>" },
        }

        -- Autocommand which triggers linting on the specified events
        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
            group = lint_augroup,
            callback = function()
                -- Only run the linter in buffers that is modifiable
                if vim.opt_local.modifiable:get() then
                    lint.try_lint()
                end
            end,
        })
    end,
}
