{ pkgs }:

let
	glasscord_base = (pkgs.callPackage ./glasscord.nix {});
in rec {
	function = {
		patch_discord_for_glasscord = glasscord_base.patch;
		set_glasscord_theme_on_startup = glasscord_base.set_theme_on_startup;
	};

	ricePkgs = {
		glasscord = function.patch_discord_for_glasscord pkgs.discord;
		glasscord_default_theme = glasscord_base.default_theme;
	};

	tests = let
			tested = with ricePkgs; [
				glasscord
				glasscord_default_theme
				(function.set_glasscord_theme_on_startup ricePkgs.glasscord_default_theme)
			];
		in pkgs.stdenv.mkDerivation {
			name = "ricenur-check";
			CONTENT = (pkgs.lib.concatStringsSep "\n"
				(map (x: "${x}") tested));

			phases = [ "installPhase" ];

			installPhase = "echo $CONTENT > $out";
	};
}
