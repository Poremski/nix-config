{ config, pkgs, ... }:

{
  i18n = {
    defaultLocale = "en_SE.UTF-8";
    glibcLocales = pkgs.callPackage ../packages/glibc-locales-en-se {
      locales = config.i18n.supportedLocales;
    };
  };
}
