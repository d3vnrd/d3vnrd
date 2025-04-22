{ config, lib, pkgs, ... }: let 
  cfg = config.programs.zsh;
in { 
  imports = [ ./starship.nix ];

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      dotDir = ".config/zsh";
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        l = "${pkgs.eza}/bin/eza -a --group-directories-first";
	ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
        tree = "${pkgs.eza}/bin/eza --color=auto --tree";
      };
    };

    programs.zsh.history = {
      path = "$XDG_CACHE_HOME/zsh_history";
      save = 10000;
      size = 10000;
      share = true;
      append = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = true;
    };

    programs.zsh.plugins = [
      # ---Auto suggestions---
      # { name = pkgs.zsh-autosuggestions.pname; src = pkgs.zsh-autosuggestions.src; }

      # ---Completions---
      # { name = pkgs.zsh-completions.pname; src = pkgs.zsh-completions.src; }
    ];

    programs.zsh.initExtra = ''
      # ---Disable beep sound---
      setopt NO_BEEP

      # ---Custom keybind---
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # ---Misc---
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
    '';

    programs.starship.enable = true;
  };
}

