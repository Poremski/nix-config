{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,

  glib,
  nspr,
  nss,
  atk,
  at-spi2-core,
  dbus,
  cups,
  expat,
  libxcb,
  libxkbcommon,
  alsa-lib,
  libgbm,

  libx11,
  libxext,
  libxcomposite,
  libxdamage,
  libxfixes,
  libxrandr,

  cairo,
  pango,
  gdk-pixbuf,
  gtk3,
  systemd,

  libusb1,
}:

stdenv.mkDerivation {
  pname = "chatgpt";
  version = "local";

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
    hash = "sha256-dgoKmNzAWkDL2KNv7B3Xsycz5qHypShThq5/r5pqsDM=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    nspr
    nss
    atk
    at-spi2-core
    dbus
    cups
    expat
    libxcb
    libxkbcommon
    alsa-lib
    libgbm

    libx11
    libxext
    libxcomposite
    libxdamage
    libxfixes
    libxrandr

    cairo
    pango
    gdk-pixbuf
    gtk3
    systemd

    libusb1
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"

    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"

    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x "$src" source
    cd source

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r usr/* "$out/"

    runHook postInstall
  '';

  meta = {
    description = "ChatGPT desktop application";
    homepage = "https://chatgpt.com/";
    platforms = [ "x86_64-linux" ];
    mainProgram = "chatgpt";
  };
}
