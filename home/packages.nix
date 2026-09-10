{ pkgs, pkgs-unstable, ... }:

# dotfiles の home-manager/packages/common.nix と同期させる
{
  home.packages = [
    pkgs.age
    pkgs-unstable.ast-grep
    pkgs-unstable.atuin
    pkgs.bash
    pkgs.bash-completion
    pkgs.bash-preexec
    pkgs.bat
    pkgs.bitwarden-cli
    pkgs.bws
    pkgs-unstable.codex
    pkgs.curl
    pkgs.delta
    (pkgs-unstable.direnv.overrideAttrs (_: { doCheck = false; }))
    pkgs-unstable.docker-sbx
    pkgs-unstable.dockerfile-pin
    pkgs-unstable.ec
    pkgs.fac
    pkgs.fd
    pkgs.ffmpeg-headless
    pkgs.fswatch
    pkgs.fzf
    # gh は programs.gh にある
    pkgs.ghq
    # nixpkgs にない
    (pkgs.callPackage ./ghtkn.nix { })
    pkgs.gibo
    pkgs-unstable.git
    pkgs.git-crypt
    pkgs.git-filter-repo
    pkgs-unstable.betterleaks
    pkgs-unstable.gitleaks
    pkgs.gnupg
    pkgs.glow
    pkgs.gron
    pkgs.jq
    pkgs-unstable.jujutsu
    pkgs-unstable.mise
    pkgs.mmv-go
    pkgs-unstable.neovim
    pkgs.nmap
    pkgs-unstable.pinact
    pkgs-unstable.proto
    pkgs.ripgrep
    pkgs.rsync
    pkgs.sops
    pkgs-unstable.sandbox-runtime
    pkgs.tig
    pkgs.tmux
    pkgs.transcrypt
    pkgs.trash-cli
    pkgs.xsel
    pkgs.yq-go
    pkgs.zoxide
  ];

  # ~/.local/share/gh/extensions が symlink になるので
  # gh extension install と gh extension upgrade は使えない
  programs.gh = {
    enable = true;
    package = pkgs-unstable.gh;

    extensions = [
      pkgs-unstable.gh-dash
      pkgs-unstable.gh-poi
      pkgs-unstable.gh-stack
    ];
  };
}
