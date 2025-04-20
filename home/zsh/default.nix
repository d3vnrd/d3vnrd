{ config, lib, pkgs, ... }: {
  options = { zsh.enable = lib.mkEnableOption "Toggle Zshell"; };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;

      autocd = true;
      dotDir = "./config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        path = "$HOME/.zsh_history";
        size = 10000;
        save = 10000;
	share = true;
	append = true;
	saveNoDups = true;
	ignoreSpace = true;
	ignoreDups = true;
	ignoreAllDups = true;
	findNoDups = true;
      };

      shellAliases = {
	ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
        tree = "${pkgs.eza}/bin/eza --color=auto --tree";
      };
    };

    programs.zsh.plugins = import ./plugin.nix { inherit pkgs; };

    programs.zsh.initExtra = ''
      # ---Path configuration---
      # ~ stole from Mischa van den Burg
      setopt extended_glob null_glob

      path = (
        $path
	$HOME/bin
	$HOME/.local/bin
	$HOME/.cargo/bin
	$HOME/.fzf/bin/
      )
      # ~ remove duplicate entries and non-existent directories
      typeset -U path
      paht = ($^path(N-/))

      export PATH

      # ---Custome keybind---
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # ---Misc---
      set -o vi
      unsetopt BEEP
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors '${"(s.:.)LS_COLORS"}'
      zstyle ':completion:*' menu select
    '';
  };
}

