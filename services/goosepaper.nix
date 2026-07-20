{pkgs, ...}:
let
goosepaper-config = pkgs.writeText "myconfig.json" (builtins.toJSON {
	version = 2;
	paper = {
		style = "FifthAvenue";
		font_size = 14;
		table_of_contents = true;
		layout = "auto";
		page_profile = "paper_pro_move";
	};
	sources = [
		# {
		# 	type = "weather";
		# 	lat = "";
		# 	lon = "";
		# }
		{ type = "wikipedia"; }
	];
	delivery = {
		folder = "Morning Brief";
	};
});
goosepaper-pkg = pkgs.stdenv.mkDerivation rec {
	pname = "goosepaper";
	version = "v0.8.1";
	src = pkgs.fetchFromGitHub {
		owner = "j6k4m8";
		repo = "goosepaper";
		rev = "${version}";
		hash = "sha256-rOrfx+yTVC+2VBt5sDVw9jRG3cpj2csZDT+LlE7EvR0=";
	};
	buildInputs = with pkgs; [
		cairo
		pango
		gdk-pixbuf
		libffi
		uv
		rmapi2
	];

	installPhase = ''
mkdir -p $out/bin
cp -r . $out/src
cat <<EOF > $out/bin/goosepaper
#!/usr/bin/env bash

export VENV_PATH="/tmp/goosepaper-venv"
export UV_PROJECT_ENVIRONMENT="\$VENV_PATH"

if [ ! -d "\$VENV_PATH" ]; then
    echo "Creating venv in \$VENV_PATH..."
    ${pkgs.uv}/bin/uv venv "\$VENV_PATH"
fi

export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath buildInputs}:\$LD_LIBRARY_PATH
cd $out/src
${pkgs.uv}/bin/uv sync
exec ${pkgs.uv}/bin/uv run goosepaper "\$@"
EOF
chmod a+x $out/bin/goosepaper
		'';
	};
in
{
  systemd.user.services.goosepaper = {
    Unit = {
      Description = "Goosepaper Daily PDF Generator";
    };

    Service = {
		Type = "oneshot";
		ExecStart = "${goosepaper-pkg}/bin/goosepaper --config ${goosepaper-config} --output /dev/null --deliver";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
