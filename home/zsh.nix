{ config, lib, pkgs, ... }: let 
  cfg = config.programs.zsh;
in { 
  imports = [ ./starship.nix ];

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      dotDir = "./config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        l = "${pkgs.eza}/bin/eza -a --group-directories-first";
	ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
        tree = "${pkgs.eza}/bin/eza --color=auto --tree";
      };
    };

    programs.zsh.plugins = [
      # ---Auto suggestions---
      { name = pkgs.zsh-autosuggestions.pname; src = pkgs.zsh-autosuggestions.src; }

      # ---Completions---
      { name = pkgs.zsh-completions.pname; src = pkgs.zsh-completions.src; }
    ];

    programs.zsh.initExtra = ''
      # ---Options---
      HISTFILE = "$XDG_CACHE_HOME/zsh_history"
      HISTSIZE=1000
      SAVEHIST=$HISTSIZE

      setopt HIST_IGNORE_SPACE
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt SHARE_HISTORY
      setopt APPEND_HISTORY
      setopt NO_BEEP
      setopt AUTOCD

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

