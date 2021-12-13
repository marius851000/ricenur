{ pkgs, ... }:

{
  kde-rounded-corner = pkgs.stdenv.mkDerivation {
    pname = "kde-rounded-corner";
    version = "8ad8f5f5eff9d1625abc57cb24dc484d51f0e1bd";

    src = pkgs.fetchFromGitHub {
      owner = "matinlotfali";
      repo = "KDE-Rounded-Corners";
      rev = "8ad8f5f5eff9d1625abc57cb24dc484d51f0e1bd";
      sha256 = "sha256-N6DBsmHGTmLTKNxqgg7bn06BmLM2fLdtFG2AJo+benU=";
    };

    dontWrapQtApps = true;

    prePatch = ''
      substituteInPlace CMakeLists.txt \
        --replace $\{MODULEPATH} "$out/share" \
        --replace $\{DATAPATH} "$out/lib/qt-5.15.3/plugins"
    ''; #TODO: auto Qt version

    nativeBuildInputs = [ pkgs.cmake pkgs.extra-cmake-modules ];

    /*postInstall = ''
      mv $out/share/kservices5/kwin/* $out/share/kservices5
    '';*/

    buildInputs = with pkgs.qt5; with pkgs.libsForQt5; [
      qtbase
      qttools
      qtx11extras
      kconfig
      kcoreaddons
      ki18n
      kio
      kglobalaccel
      kinit
      kwin
      pkgs.xorg.libXdmcp
      pkgs.libepoxy
    ];
  };
}
