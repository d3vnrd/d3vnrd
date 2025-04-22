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
      "HIST_FIND_NO_DUPS"
      "HIST_SAVE_NO_DUPS"
      "SHARE_HISTORY"
      "APPEND_HISTORY"
      "NO_BEEP"
      "auto_cd"
    ];

    programs.zsh.histSize = 1000;
    programs.zsh.histFile = "$XDG_CACHE_HOME/zsh_history";

    programs.zsh.shellInit = ''
    '';

    programs.zsh.interactiveShellInit = ''
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
    '';

    programs.zsh.promptInit = ''
      autoload -Uz vcs_info 
      precmd () { vcs_info }

      PS1="%F{#a1b56c}%B%n@%m%b %1~:%f"
    '';

    programs.zsh.shellAliases = {
      l = "${pkgs.eza}/bin/eza -a --group-directories-first";
      ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
      tree = "${pkgs.eza}/bin/eza --color=auto --tree";
    };

    programs.zsh.zsh-autoenv = {
      # TODO: add packages to auto source
      enable = true;
    };
  };
}

