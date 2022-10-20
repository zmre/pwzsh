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
        pkgs = import nixpkgs { inherit system; };
        config = pkgs.writeTextFile {
          name = "zshrc";
          text =   builtins.readFile ./config/zshrc + ''
            fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
            source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
            source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            zmodload -a autocomplete
            zmodload -a complist
            #bindkey '^I' fzf-completion
          '';
        };

      in rec {
        dependencies = with pkgs; [
          bat
          btop
          coreutils
          cowsay # this is here to help with testing
          curl
          exa
          exif
          fd
          file
          fzf
          fzy
          git
          gnused
          less
          mdcat # colorize markdown
          pstree
          inputs.pwnvim.packages.${system}.pwnvim
          ripgrep
          starship
          zoxide
          zsh
          zsh-completions
          zsh-autocomplete
          zsh-autosuggestions
          zsh-syntax-highlighting
          #lf
          #tmux
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
            cp ${config} $out/config/.zshrc
            makeWrapper "${zsh}/bin/zsh" "$out/bin/pwzsh" --set ZDOTDIR "$out/config" --set PWZSH 1 --prefix PATH : "$out/bin:"${pkgs.lib.makeBinPath dependencies}
          '';
        };
        apps.pwzsh = flake-utils.lib.mkApp {
          drv = packages.pwzsh;
          name = "pwzsh";
          exePath = "/bin/pwzsh";
        };
        packages.default = packages.pwzsh;
        apps.default = apps.pwzsh;
        # devShell = pkgs.mkShell {
        #   buildInputs = dependencies;

        #   shellHook = ''
        #   '';
        # };
      }
    );

}
