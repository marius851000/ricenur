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
in {
  nixpkgs.overlays = [
    (self: super: {
      plasma5 = super.plasma5 // {
        plasma-workspace = (super.plasma5.plasma-workspace.overrideAttrs
          (oldAttrs: rec {
            buildInputs = oldAttrs.buildInputs
              ++ [ pkgs.qt514.qtwebsockets pkgs.python3 ] ++ python_package;
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ python_package;
            postInstall = (oldAttrs.postInstall or "") + ''
              wrapProgram $out/bin/plasmashell \
              	--prefix PATH : ${pkgs.python3}/bin:${pkgs.pulseaudio}/bin:${pkgs.binutils-unwrapped}/bin \
              	--prefix PYTHONPATH : $PYTHONPATH \
              	--prefix LD_LIBRARY_PATH : ${pkgs.pulseaudio}/lib
            '';
          }));
      };
    })
  ];

  environment.systemPackages = [ panon ];
}
