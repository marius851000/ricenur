{ pkgs ? import <nixpkgs> {} }:

let
  glasscord_base = (pkgs.callPackage ./glasscord.nix {});
in
rec {
  function = {
    patch_discord_for_glasscord = glasscord_base.patch_discord;
    patch_vscode_for_glasscord = glasscord_base.patch_vscode;
    set_glasscord_theme_script = glasscord_base.set_theme_on_startup_script;
  };

  ricePkgs = {
    glasscord_discord = function.patch_discord_for_glasscord pkgs.discord;
    glasscord_default_theme_discord = glasscord_base.default_theme_discord;
    glasscord_vscode = function.patch_vscode_for_glasscord pkgs.vscode glasscord_base.default_theme_vscode;
    glasscord_vscodium = function.patch_vscode_for_glasscord pkgs.vscodium glasscord_base.default_theme_vscode;
    plasmoids = (pkgs.callPackage ./plasmoids.nix {});
    kwinmodules = (pkgs.callPackage ./kwinmodules.nix {});
  };

  tests = let
    tested = with ricePkgs; [
      glasscord_vscodium
      glasscord_default_theme
      plasmoids.advanced_radio_player
      plasmoids.animated_wallpaper
      kwinmodules.kde-rounded-corner
    ];

  in
    pkgs.stdenv.mkDerivation {
      name = "ricenur-check";
      CONTENT = (
        pkgs.lib.concatStringsSep "\n"
          (map (x: "${x}") tested)
      );

      phases = [ "installPhase" ];

      installPhase = "echo $CONTENT > $out";
    };
}
