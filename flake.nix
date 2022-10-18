{
  description = "PW's Zsh (pwzsh) Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    pwnvim.url = "github:zmre/pwnvim";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              pwnvim = inputs.pwnvim;
            })];
        };

      in rec {
        dependencies = with pkgs; [
          fd
          ripgrep
          fzy
          fzf
          zoxide
          exa
          curl
          git
          less
          file
          exif
          mdcat # colorize markdown
          pkgs.btop
          pstree
          bat
          zsh-completions
          zsh-autocomplete
          zsh-autosuggestions
          zsh-syntax-highlighting
          starship
          #lf
          #tmux
          cowsay # this is here to help with testing
        ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ ueberzug ];

        packages.pwzsh = with pkgs; stdenv.mkDerivation rec {
          version = "1.0.0";
          name = "pwzsh";
          inherit system;
          src = self;
          buildInputs = [ zsh ];
          nativeBuildInputs = [ makeWrapper ];
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p "$out/bin"
            mkdir -p "$out/config"
            cp ./config/.zshrc $out/config
            makeWrapper "${zsh}/bin/zsh" "$out/bin/zsh" --set ZDOTDIR "$out/config" --set PWZSH 1 --prefix PATH : ${pkgs.lib.makeBinPath dependencies}
          '';
        };
        apps.pwzsh = flake-utils.lib.mkApp {
          drv = packages.pwzsh;
          name = "pwzsh";
          exePath = "/bin/zsh";
        };
        packages.default = packages.pwzsh;
        apps.default = apps.pwzsh;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            packages.pwzsh
          ] ++ dependencies;

          shellHook = ''
            zsh
          '';
        };
      }
    );

}
#source /nix/store/dfxbf136hkvyhlca9z4dzv145rsl64l3-zsh-syntax-highlighting-0.7.1/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
