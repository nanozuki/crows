pkgs: name: template: data:
pkgs.stdenv.mkDerivation {
  name = "${name}";

  nativeBuildInpts = [ pkgs.mustache-go ];

  # Pass Json as file to avoid escaping
  passAsFile = [ "jsonData" ];
  jsonData = builtins.toJSON data;

  # Disable phases which are not needed. In particular the unpackPhase will
  # fail, if no src attribute is set
  phases = [
    "buildPhase"
    "installPhase"
  ];

  buildPhase = ''
    ${pkgs.mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
  '';

  installPhase = ''
    cp rendered_file $out
  '';
}
