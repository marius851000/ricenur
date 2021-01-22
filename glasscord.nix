{ pkgs }:

let
  glasscord_asar = pkgs.fetchurl {
    url = "https://github.com/AryToNeX/Glasscord/releases/download/v0.9999.9999/glasscord.asar";
    sha256 = "uOLFyZvSHHpBhNKFemz1W4ZBVmHm4eQUeMr8D4CzhfE=";
  };

  glasscord_src = pkgs.fetchFromGitHub {
    owner = "AryToNeX";
    repo = "Glasscord";
    rev = "v0.9999.9999";
    sha256 = "oeoupLUCLAQ6Ewr5cPtUh4pCtXU8kPwfIhHp0ct1ReE=";
  };
in
{
  patch_discord = discord:
    discord.overrideAttrs (
      oldAttrs: {
        installPhase = oldAttrs.installPhase + "\n" + ''
          			pushd $out/opt/Discord/resources/
          			mkdir app
          			asar ef app.asar package.json
          			mv package.json app
          			cp ${glasscord_asar} app/glasscord.asar
          			substituteInPlace app/package.json \
          				--replace '"main": "app_bootstrap/index.js"' '"main": "./glasscord.asar"'
          			popd
          		'';
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.nodePackages.asar ];
      }
    );

  patch_vscode = vscode: theme:
    vscode.overrideAttrs (
      old: {
        installPhase = old.installPhase + "\n" + ''
                            	pushd $out/lib/vscode/resources/app/
                              cp package.json package.original.json
                              cp ${glasscord_asar} glasscord.asar
                              substituteInPlace package.json \
                                --replace ./out/main ./glasscord.asar
          					          cat ${theme} >> out/vs/workbench/workbench.desktop.main.css
                               	popd
        '';
      }
    );

  default_theme_discord = pkgs.stdenv.mkDerivation {
    name = "style-glasscord.css";

    src = glasscord_src;

    installPhase = ''
      cp extras/discord_example_theme/discord_example.theme.css $out"
    '';
  };

  default_theme_vscode = pkgs.stdenv.mkDerivation {
    name = "style-vscode";
    src = glasscord_src;
    installPhase = ''
      cp extras/vscode_example_theme/vscode_example.theme.css $out
      substituteInPlace $out --replace "rgba(0,0,0,0.5)" "rgba(0.1,0.1,0.1,0.8)"
    '';
  };

  set_discord_theme_on_startup_script = theme: let
    style_file = pkgs.writeText "glasscord-theme" (
      builtins.toJSON {
        cssPath = theme;
      }
    );
  in
    ''
      		mkdir -p /home/marius/.config/glasscord/discord/CSSLoader/
      		cp -f ${style_file} ~/.config/glasscord/discord/CSSLoader/config.json5
      	'';
}
