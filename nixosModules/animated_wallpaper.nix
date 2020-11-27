{ pkgs, config, ... }:

with builtins;

let
	ricenur = pkgs.callPackage ../default.nix {};
	animated_image_wallpaper = ricenur.ricePkgs.plasmoids.animated_wallpaper;
in {
	nixpkgs.overlays = [ (self: super: {
		plasma5 = super.plasma5 // {
			plasma-workspace = (super.plasma5.plasma-workspace.overrideAttrs (oldAttrs: rec {
				buildInputs = oldAttrs.buildInputs ++ [pkgs.qt5.qtimageformats];
			}));
		};
	})];

	environment.systemPackages = [
		animated_image_wallpaper
	];
}
