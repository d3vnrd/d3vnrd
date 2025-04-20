{ config, lib, pkgs, ... }: 
{
  config = lib.mkIf config.programs.zsh.enable {
    programs.zsh = {
      autocd = true;
      dotDir = "./config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        path = "${config.xdg.cacheHome}/zsh/zsh_history";
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

      PS1="%F{#008000}%B%n@%m%b %1~:%f" #TODO: Config prompt for zshell
    '';

    programs.bat.enable = true;
  };
}

