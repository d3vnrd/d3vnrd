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
        path = "${config.xdg.dataHome}/zsh/zsh_history";
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
        l = "${pkgs.eza}/bin/eza --a --group-directories-first";
	ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
        tree = "${pkgs.eza}/bin/eza --color=auto --tree";
      };
    };

    programs.zsh.plugins = [
      # ---Auto suggestions---
      { name = pkgs.zsh-autosuggestions.pname; src = pkgs.zsh-autosuggestion.src; }

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
      PROMPT="$\n%K{#2E3440}%F{#E5E9F0}$(date +%_I:%M%P) %K{#3b4252}%F{#ECEFF4} %n %K{#4c566a} %~ %f%k ❯ "
      echo -e "\n\033[48;2;46;52;64;38;2;216;222;233m $0 \033[0m\033[48;2;59;66;82;38;2;216;222;233m $(uptime -p | cut -c 4-) \033[0m\033[48;2;76;86;106;38;2;216;222;233m $(uname -r) \033[0m"
    '';
  };
}

