{ pkgs }:

{
	patch = discord: let
		glasscord_asar = pkgs.fetchurl {
			url = "https://github.com/AryToNeX/Glasscord/releases/download/v0.9999.9999/glasscord.asar";
			sha256 = "uOLFyZvSHHpBhNKFemz1W4ZBVmHm4eQUeMr8D4CzhfE=";
		};
	in
	discord.overrideAttrs (oldAttrs: {
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
	});

	default_theme = pkgs.stdenv.mkDerivation {
    name = "style-glasscord";
		
    src = pkgs.fetchFromGitHub {
      owner = "AryToNeX";
      repo = "Glasscord";
      rev = "v0.9999.9999";
      sha256 = "oeoupLUCLAQ6Ewr5cPtUh4pCtXU8kPwfIhHp0ct1ReE=";
    };

    installPhase = ''
      cp extras/discord_example_theme/discord_example.theme.css $out
    '';
  };
}
