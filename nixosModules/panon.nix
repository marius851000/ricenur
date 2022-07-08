{ config, pkgs, ... }:
let
  python_package = with pkgs.python3Packages; [
    cffi
    numpy
    docopt
    websockets
    pillow
  ]; # for pulseaudio

  ricenur = pkgs.callPackage ../default.nix {};
  panon = ricenur.ricePkgs.plasmoids.panon;
  tool = import ../tool.nix;
in
{
  nixpkgs.overlays = [
    (
      tool.make_plasma_workspace_overlay (
        pkgs: old: {
          buildInputs = old.buildInputs
          ++ [ pkgs.qt5.qtwebsockets ] ++ python_package;
          nativeBuildInputs = old.nativeBuildInputs ++ python_package;
          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/plasmashell \
            	--prefix PATH : ${pkgs.pulseaudio}/bin:${pkgs.binutils-unwrapped}/bin \
            	--prefix LD_LIBRARY_PATH : ${pkgs.pulseaudio}/lib
          '';
        }
      )
    )
  ];

  environment.systemPackages = [ panon ];
}

#TODO: check if it possible to minise the content of the wrapProgram in some way (panon should call python somewhere, patch for the absolute path)
