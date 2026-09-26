{ pkgs, ... }:

{
  home = {
    username = "javier";
    homeDirectory = "/home/javier";
    stateVersion = "26.05";

    packages = [ pkgs.gh ];
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "7A4F2E1CAF436D00CC46DE5B022FACD79B10C33A" ];
    pinentry.package = pkgs.pinentry-qt;
  };

  programs.git = {
    enable = true;

    signing = {
      key = "D85178CF97840B3927A80750FC7EE837A78AC7BD";
      format = "openpgp";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Javier Poremski";
        email = "javier@poremski.se";
      };

      init.defaultBranch = "master";
    };
  };
}
