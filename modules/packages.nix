{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    codex
    git
  ];

  users.users.javier.packages = with pkgs; [
    kdePackages.kate
    thunderbird
  ];
}
