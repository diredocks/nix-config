{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      neofetch = "fastfetch";
    };
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-fzf-history-search";
        src = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search";
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = ["git" "ssh-agent" "z"];
      extraConfig = ''
        zstyle :omz:plugins:ssh-agent identities github_key
        zstyle :omz:plugins:ssh-agent lifetime 24h
        zstyle :omz:plugins:ssh-agent lazy yes
      '';
    };
  };
}
