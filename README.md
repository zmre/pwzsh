# Pre-configured zsh shell via flake

This is a flake that produces a minimal zsh shell that should work reasonably well in crappy environments like a fresh linux console or Mac Terminal. It doesn't require fancy fonts and assumes a limited number of available colors.

I use it when setting up new systems before I've bootstrapped nix and a full environment or when I'm using someone else's config/computer and just need something more familiar so I can be more productive.

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
* eza
* exif
* fd
* fzf
* git
* pstree
* nvim
* ripgrep

The nvim installed also has a [full configuration](https://github.com/zmre/pwnvim/) that should work reasonably well (but not pretty) in weak terminals.

