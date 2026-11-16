{
  lib,
  fetchurl,
  glibcLocales,
  locales,
}:
let
  # Backport locale data only; keep the archive compatible with stable glibc.
  enSE = fetchurl {
    url = "https://raw.githubusercontent.com/bminor/glibc/a6eb8285d9bfb7ec0875b85ca356e833ff964d4f/localedata/locales/en_SE";
    hash = "sha256-9Nz/xZfcaOJ/3DV+FOiOb6g8E3HvFHCu/jokMWSGDVU=";
  };
in
(glibcLocales.override {
  allLocales = lib.elem "all" locales;
  inherit locales;
}).overrideAttrs
  (old: {
    postPatch = (old.postPatch or "") + ''
      cp ${enSE} localedata/locales/en_SE
      # Newer glibc already lists this locale; avoid duplicating its entry.
      if ! grep -q '^en_SE.UTF-8/UTF-8' localedata/SUPPORTED; then
        echo 'en_SE.UTF-8/UTF-8 \' >> localedata/SUPPORTED
      fi
    '';
  })
