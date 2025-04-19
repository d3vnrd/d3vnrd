[
  # ---Spaceship prompt---
  {
    name = "spaceship-prompt";
    src = pkgs.fetchFromGitHub {
      owner = "spaceship-prompt";
      repo = "spaceship-prompt";
      rev = "v4.18.0";
      sha256 = lib.fakeSha256;
    };
  }

  # ---Auto suggestions---
  {
    name = "zsh-autosuggestions";
    src = pkgs.fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-autosuggestions";
      rev = "v0.4.0";
      sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
    };
  }

  # ---Completions---
  {
    name = "zsh-completions";
    src = pkgs.fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-completions";
      rev = "0.35.0";
      sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg";
    };
  }
]


