{ pkgs, config, ... }:

let
	ricenur = pkgs.callPackage ../default.nix {};
	advanced_radio = ricenur.ricePkgs.plasmoids.advanced_radio_player;
in
{
	environment.variables = {
		GST_PLUGIN_SYSTEM_PATH_1_0 = "/run/current-system/sw/lib/gstreamer-1.0/";
		GIO_EXTRA_MODULES = [ "${pkgs.glib-networking.out}/lib/gio/modules" ];
	};

	environment.systemPackages = with pkgs; [
		advanced_radio
		gst_all_1.gst-plugins-good
		gst_all_1.gst-plugins-bad
		gst_all_1.gst-plugins-ugly
		gst_all_1.gst-plugins-base
		gst_all_1.gst-libav
		gst_all_1.gstreamer
		gst_all_1.gst-vaapi
		gst_all_1.gst-validate
		gst_all_1.gst-rtsp-server
	];
}
