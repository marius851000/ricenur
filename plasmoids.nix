{ pkgs, ... }:


{
	advanced_radio_player = pkgs.stdenv.mkDerivation {
		name = "plasma-advanced-radio";
		src = pkgs.fetchurl {
			url = "https://github.com/marius851000/ricenur-data/raw/b89ae5f5166c955f181eb31953e12b238b29c35d/org.kde.plasma.advancedradio.tar.gz";
			sha256 = "FSXDfxuGfjnOOurrg9Uo1uRYBb3ruzI/wvsvpfmvD5M=";
		};

		installPhase = ''
			mkdir -p $out/share/plasma/plasmoids/org.kde.plasma.advancedradio
			cp -rf * $out/share/plasma/plasmoids/org.kde.plasma.advancedradio
		'';
	};
}
