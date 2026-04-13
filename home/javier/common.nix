{config, ...}: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  xdg.dataFile."user-places.xbel".source = ../../config/plasma/user-places.xbel;

  home = {
    username = "javier";
    homeDirectory = "/home/javier";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    stateVersion = "25.11";
  };
}
