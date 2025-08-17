{
  description = "PW's Zsh (pwzsh) Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    pwnvim.url = "github:zmre/pwnvim";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in rec {
      dependencies = with pkgs;
        [
          # atuin # shell history?
          bat
          btop
          coreutils
          cowsay # this is here to help with testing
          curl
          direnv
          du-dust
          duf # df alternative showing free disk space
          eza
          exif
          fd
          file
          fzf
          fzy
          git
          gnused
          jq
          less
          mdcat # colorize markdown
          neofetch
          pstree
          inputs.pwnvim.packages.${system}.pwnvim
          ripgrep
          starship
          yazi
          zoxide
          zsh
          zsh-completions
          zsh-autocomplete
          zsh-autosuggestions
          zsh-syntax-highlighting
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ueberzug];

      packages.pwzsh = with pkgs;
        stdenv.mkDerivation rec {
          version = "1.0.0";
          name = "pwzsh";
          inherit system;
          src = self;
          buildInputs = [zsh] ++ dependencies;
          nativeBuildInputs = [makeWrapper];
          phases = ["installPhase"];

          installPhase = ''
            mkdir -p "$out/bin"
            mkdir -p "$out/config"
            export zsh_autosuggestions="${pkgs.zsh-autosuggestions}"
            export zsh_autocomplete="${pkgs.zsh-autocomplete}"
            export zsh_syntax_highlighting="${pkgs.zsh-syntax-highlighting}"
            export fzf="${pkgs.fzf}"
            export starship="${pkgs.starship}"
            export zoxide="${pkgs.zoxide}"
            export direnv="${pkgs.direnv}"
            export zsh_completions="${pkgs.zsh-completions}"
            export starshipconfig="${./config/starship.toml}"
            substituteAll $src/config/zshrc $out/config/.zshrc
            makeWrapper "${zsh}/bin/zsh" "$out/bin/pwzsh" --set SHELL_SESSIONS_DISABLE 1 --set ZDOTDIR "$out/config" --set PWZSH 1 --prefix PATH : "$out/bin:"${
              pkgs.lib.makeBinPath dependencies
            }
          '';
        };
      apps.pwzsh = flake-utils.lib.mkApp {
        drv = packages.pwzsh;
        name = "pwzsh";
        exePath = "/bin/pwzsh";
      };
      packages.default = packages.pwzsh;
      apps.default = apps.pwzsh;
    });
}
