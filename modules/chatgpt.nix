{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.callPackage ../packages/chatgpt { })
  ];
}
