{
	description = "nixos modules for various ricing related stuff";

	outputs = { self }: {
		nixosModules = {
			plasma_advanced_radio = import ./nixosModules/plasma_advanced_radio.nix;
			animated_wallpaper = import ./nixosModules/animated_wallpaper.nix;
			panon = import ./nixosModules/panon.nix;
		};
	};
}
