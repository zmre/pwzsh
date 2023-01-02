# README

This is a flake that produces a minimal zsh shell that should work reasonably well in crappy environments like a fresh linux console or Mac Terminal. It doesn't require fancy fonts and assumes a limited number of available colors.

To run it if you have nix installed, do this:

```bash
nix --extra-experimental-features "nix-command flakes" run github:zmre/pwzsh
```

That will drop you into a zsh shell with autocomplete and colors and a basic prompt.

Additionally you'll get some utilities, including (not copmrehensive):

* bat
* btop
* curl
* direnv
* exa
* exif
* fd
* fzf
* git
* pstree
* nvim
* ripgrep

The nvim installed also has a [full configuration](https://github.com/zmre/pwnvim/) that should work reasonably well (but not pretty) in weak terminals.

