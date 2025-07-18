{ pkgs, ... }: {
	home.file = {
		# ".config/openxr/1/active_runtime-monado.json".text = (import ./config/monado-runtime.json.nix) {inherit (pkgs) monado; };
		# ".config/openvr/openvrpaths.vrpath.monado".text = (import ./config/openvrpath.json.nix) { inherit (pkgs) opencomposite; };
		# "./config/openxr/1/active_runtime.json".source = mkMutableSymlink "~/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";
		# "OpenComposite".source = "${pkgs.opencomposite}/lib/opencomposite";
		# "Xrizer".source = "${pkgs.xrizer}/lib/xrizer";
	};
}
