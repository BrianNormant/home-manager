{synthesia}:
synthesia.overrideAttrs {
	postInstall = ''
	cat <(echo "export DISPLAY=") $out/bin/synthesia > tmp
	rm $out/bin/synthesia
	mv tmp $out/bin/synthesia
	chmod +x $out/bin/synthesia
	'';
}
