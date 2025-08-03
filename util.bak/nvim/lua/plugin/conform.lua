return {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
        notify_on_error = false,

        format_on_save = function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                }
            end
        end,

        formatters = {
            dprint = {
                command = 'dprint',
                args = {
                    'fmt',
                    '--stdin',
                    '$FILENAME',
                    '--config',
                    vim.api.nvim_get_runtime_file('.dprint.jsonc', true)[1],
                },
                stdin = true,
            },
        },

        formatters_by_ft = {
            lua = { 'stylua' },
            nix = { 'alejandra' },
            markdown = { 'dprint' },
            python = { 'dprint', 'isort', 'black', stop_after_first = true },
            html = { 'dprint' },
            css = { 'dprint' },

            -- For filetypes without a formatter
            ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
    },
}
