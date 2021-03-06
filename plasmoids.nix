{ pkgs, ... }:


let
	base_plasmoid_dir = "$out/share/plasma/plasmoids";
in {
	advanced_radio_player = pkgs.stdenv.mkDerivation {
		name = "plasma-advanced-radio";
		src = pkgs.fetchurl {
			url = "https://github.com/marius851000/ricenur-data/raw/b89ae5f5166c955f181eb31953e12b238b29c35d/org.kde.plasma.advancedradio.tar.gz";
			sha256 = "FSXDfxuGfjnOOurrg9Uo1uRYBb3ruzI/wvsvpfmvD5M=";
		};

		installPhase = ''
			mkdir -p ${base_plasmoid_dir}/org.kde.plasma.advancedradio
			cp -rf * ${base_plasmoid_dir}/org.kde.plasma.advancedradio
		'';
	};

	animated_wallpaper = pkgs.stdenv.mkDerivation {
		name = "animated_image_wallpaper";

		src = pkgs.fetchFromGitHub {
			owner = "dark-eye";
			repo = "com.darkeye.animatedImage";
			rev = "v0.2.8";
			sha256 = "VS9khjD5YcMZgOcPyIZ3nGuZn17cLgwTuHR6EfX1CaM=";
		};

		installPhase = ''
			mkdir -p $out/share/plasma/wallpapers/com.darkeye.animatedImage
			cp -rf * $out/share/plasma/wallpapers/com.darkeye.animatedImage
		'';
	};

	panon = pkgs.stdenv.mkDerivation rec {
		pname = "panon";
		version = "0.4.2";

		nativeBuildInputs = [
			pkgs.cmake pkgs.gettext
		];

		phases = [ "unpackPhase" "buildPhase" "installPhase" ];

		src = pkgs.fetchFromGitHub {
			owner = "rbn42";
			repo = pname;
			rev = "v${version}";
			sha256 = "6mitc6pg/g2mBubOFjxh2B+sSko0p0h6uFiVjXLvt7k=";
			fetchSubmodules = true;
		};

		buildPhase = ''
			pushd translations
			mkdir build
			cd build
			cmake .. -DLOCALE_INSTALL_DIR=${base_plasmoid_dir}/panon/contents/locale
			find
			popd
		'';

		installPhase = ''
			mkdir -p ${base_plasmoid_dir}/panon
			cp -rL plasmoid/* ${base_plasmoid_dir}/panon
			pushd translations/build
			make install
		'';
	};
}
