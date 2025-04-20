{ config, lib, pkgs, ... }: let
  cfg = config.programs.zsh;
in { 
  config = lib.mkIf cfg.enable {
    programs.zsh.syntaxHighlighting.enable = true;
    programs.zsh.autosuggestions.enable = true;
    programs.zsh.enableCompletion = true;

    programs.zsh.setOptions = [
      "HIST_IGNORE_SPACE"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_NO_DUPS"
      "HIST_FIND_NO_DUPS"
      "HIST_SAVE_NO_DUPS"
      "SHARE_HISTORY"
      "APPEND_HISTORY"
      "NO_BEEP"
      "auto_cd"
    ];

    programs.zsh.histSize = 1000;
    programs.zsh.histFile = "${config.xdg.cacheHome}/zsh/zsh_history"

    programs.zsh.shellInit = ''
      # ---Custom keybind---
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # ---Misc---
      set -o vi
      unsetopt BEEP
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select

      # ---Prompt config---
      autoload -Uz vcs_info 
      precmd () { vcs_info }

      PS1="%F{#008000}%B%n@%m%b %1~:%f"
    '';

    programs.zsh.shellAliases = {
      l = "${pkgs.eza}/bin/eza -a --group-directories-first";
      ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
      tree = "${pkgs.eza}/bin/eza --color=auto --tree";
    };

    programs.zsh.zsh-auto-autoenv = {
      enable = true;
      package = {
        
      };
    };

    programs.bat.enable = true;

    # programs.zsh.plugins = [
    #   # ---Auto suggestions---
    #   { name = pkgs.zsh-autosuggestions.pname; src = pkgs.zsh-autosuggestions.src; }
    #
    #   # ---Completions---
    #   { name = pkgs.zsh-completions.pname; src = pkgs.zsh-completions.src; }
    # ];
  };
}

