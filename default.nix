{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation rec {
  name = "spotify-dbus";

  src = builtins.path {
    name = "${name}-source";
    path = ./.;
  };

  nativeBuildInputs = [pkgs.makeWrapper];

  propagatedBuildInputs = [
    pkgs.dbus
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    cp ./main.sh $out/bin/${name} && chmod +x $out/bin/${name}

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram ${placeholder "out"}/bin/${name} \
      --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.dbus]}
  '';

  meta = {
    mainProgram = "spotify-dbus";
  };
}
