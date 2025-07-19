---@type vim.lsp.Config
return {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    root_makers = { 'flake.nix', 'git' },
}
