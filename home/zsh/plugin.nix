{ pkgs }: [
  # ---Spaceship prompt---
  { name = pkgs.spaceship-prompt.pname; src = pkgs.spaceship-prompt.src; }

  # ---Auto suggestions---
  { name = pkgs.zsh-autosuggestions.pname; src = pkgs.zsh-autosuggestion.src; }

  # ---Completions---
  { name = pkgs.zsh-completions.pname; src = pkgs.zsh-completions.src; }
]


