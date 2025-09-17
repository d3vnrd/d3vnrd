{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.M.shell = mkOption {
    type = types.enum ["zsh" "bash"];
    default = "zsh";
    description = "Selected shell for programs support.";
  };

  config = {
    programs.zsh = {
      enable = mkForce (config.M.shell == "zsh");
      dotDir = config.xdg.configHome + "/zsh";
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        l = "${pkgs.eza}/bin/eza -a --group-directories-first";
        ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
        tree = "${pkgs.eza}/bin/eza --color=auto --tree";
      };

      history = {
        path = "${config.xdg.cacheHome}/zsh/zsh_history";
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

      plugins = with pkgs; [
        # ---Auto suggestions---
        # { name = pkgs.zsh-autosuggestions.pname; src = pkgs.zsh-autosuggestions.src; }

        # ---Completions---
        # { name = pkgs.zsh-completions.pname; src = pkgs.zsh-completions.src; }
      ];

      initContent = ''
        # ---Fix weird color behaviour with tmux---
        export TERM="xterm-256color"

        # ---Disable beep sound---
        setopt NO_BEEP

        # ---Custom keybind---
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        # ---Misc---
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu select
      '';
    };
  };
}
