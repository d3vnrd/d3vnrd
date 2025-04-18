On-hold --> I want to make neovim compatible with Nix without having to migrate all off my lua config to nix. Currently, LSP + Mason the main problems cause they directly related to how nix derivative works.

TODO:
- [ ] `config.lib.file.makeOutOfSymlink` this could potentialy solve compatibility of lua config
- [ ] Gotta find out how i can install lsp dependencies using nixpkgs
- [ ] Some other users seem to use `overlay` features 
