# basic documentation about ricenur

Welcome to the documentation of ricenur. You find here documentation about this repository dedicated to help you enhance your graphical environment when you use the nix package manager (specifically under NixOS).

To import this package, it is expected you load the `default.nix` file.

## nixos modules (aka `flake.nix`)
I also added nixos module. The name of each module will be provided under the appropriate section of the configuration.

There are two way to enable them
### your are using `flake.nix` for the system configuration
You need to add `inputs.ricenur.url = "github:marius851000/ricenur";` below your input, add ricenur as an input for the output function.

You can include the module using by adding them to the import like:
```
imports = [
	...
	ricenur.nixosModules.plasma_advanced_radio
]
```
### not using a flake
I haven't tried this, but here are some pointer:

- add `ricenur` to nix channel / pin it
- add `<ricenur/nixosModules/{module name}.nix>` in the `imports = []` part of the configuration.nix
## glasscord
I included various stuff for glasscord (discord with transparency).

### `function.patch_discord_for_glasscord`
You can use this function to patch an existing discord derivation.

For example, you can use `ricenur.function.patch_discord_for_glasscord pkgs.discord`

### `ricePkgs.glasscord`
A glasscord enabled discord

### `ricePkgs.glasscord_default_theme`
Default glasscord theme.

### `function.set_glasscord_theme_on_startup`
Will set the theme passed as argument to be loaded at login. You can add it to `home.packages` in home-manager for it to be loaded at login.

It need to be copied, and can't be linked from the nix store, as glasscord doesn't start if it can't write it.

Example : `ricenur.function.set_glasscord_theme_on_startup ricenur.ricePkgs.glasscord_default_theme`

## plasmoids
This nur also include some plasmoids. You can install them system wide by adding them to `environment.systemPackages` in the system-wide `configuration.nix` file (of NixOS, usually in `/etc/nixos`. Remember to rebuild with `sudo nixos-rebuild` and restart the computer to see the effect).

Plasma use the XDG_DATA_DIRS environment variable to detect them, and this variable is automantically created by nixos.

### `ricePkgs.plasmoids.advanced_radio_player`
add the advanced media player plasmoids, wich is a radio player that can be customized.

Please note that it may need some environment variable set. You should need to add the followind code in your `configuration.nix`.

```

environment.variables = {
	GST_PLUGIN_SYSTEM_PATH_1_0 = "/run/current-system/sw/lib/gstreamer-1.0/";
	GIO_EXTRA_MODULES = [ "${pkgs.glib-networking.out}/lib/gio/modules" ];
};

environment.systemPackages = with pkgs; [
	gst_all_1.gst-plugins-good
	gst_all_1.gst-plugins-bad
	gst_all_1.gst-plugins-ugly
	gst_all_1.gst-plugins-base
	gst_all_1.gst-libav
	gst_all_1.gstreamer
	gst_all_1.gst-vaapi
];
```
(remember that `environment.systemPackages` also need the `ricenur.ricePkgs.plasmoids.advanced_radio_player` to work)

All of the upper is done automatically (including adding `advanced_radio_player` to the `systemPackages`) by importing the nixos module `plasma_advanced_radio`.

### `ricePkgs.plasmoids.animated_wallpaper`
Add the animated wallpaper, who allow to play animated image in the wallpaper. By default, it only support gif. To add support for webp, you need to add this to your `configuration.nix`

```
nixpkgs.overlays = [ (self: super: {
	plasma5 = super.plasma5 // {
		plasma-workspace = (super.plasma5.plasma-workspace.overrideAttrs (oldAttrs: rec {
			buildInputs = oldAttrs.buildInputs ++ [pkgs.qt514.qtimageformats];
		}));
	};
})];
```

(this will add the `qt514.qtimageformats` dependancies to `plasma.plasma5`)

The nixos module is `animated_wallpaper`. There are no additional step to do when using it.
