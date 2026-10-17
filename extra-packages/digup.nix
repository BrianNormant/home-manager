{
	lib,
	appimageTools,
	fetchurl,
}: let
	version = "0.7.0-beta.1";
	pname = "digup";

	src = fetchurl {
		url = "https://github.com/ARahim3/DigUp/releases/download/v${version}/DigUp_${version}_amd64.AppImage";
		hash = "sha256-EWe7D6+nLxobFbcieUfa5j2C1J1nnEGX/t7b0LbyxTs=";
	};
in
appimageTools.wrapType2 {
	inherit pname version src;

	meta = {
		description = "DigUp";
		homepage = "https://github.com/ARahim3/DigUp";
		downloadPage = "https://github.com/ARahim3/DigUp/releases";
		license = lib.licenses.mit;
		sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
		platforms = [ "x86_64-linux" ];
	};
}

