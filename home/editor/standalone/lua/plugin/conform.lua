-- File auto format
return {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    init = function()
        -- Use conform for gq
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
        notify_on_error = false,

        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
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

        formatters_by_ft = {
            lua = { 'stylua' },
            nix = { 'alejandra' },
            python = { 'isort', 'black' },
            markdown = { 'prettier' },

            -- For filetypes without a formatter
            ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
    },
}
