{ pkgs, config, ... }:

with builtins;

let
  tool = import ../tool.nix;
  ricenur = pkgs.callPackage ../default.nix { inherit pkgs; };
  animated_image_wallpaper = ricenur.ricePkgs.plasmoids.animated_wallpaper;
in {
  nixpkgs.overlays = [
    (tool.make_plasma_workspace_overlay (pkgs: old: {
      buildInputs = old.buildInputs ++ [ pkgs.libsForQt5.qtimageformats ];
    }))
  ];

  environment.systemPackages = [ animated_image_wallpaper ];
}
