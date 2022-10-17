{
  description = "PW's Zsh (pwzsh) Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

      in rec {
        dependencies = with pkgs; [
          fd
          ripgrep
          fzy
          zoxide
          cowsay
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
            makeWrapper "${zsh}/bin/zsh" "$out/bin/zsh" --set ZDOTDIR "./config" --set PWZSH 1 --prefix PATH : ${pkgs.lib.makeBinPath dependencies}
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
