{ fetchzip, lib, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Arcticons Sans";
    homepage = "https://github.com/arcticons-team/arcticons-font";
    license = lib.licenses.ofl;
    longDescription = "The font used by Arcticons.";

    maintainers = with lib.maintainers; [
      asininemonkey
    ];

    platforms = lib.platforms.all;
  };

  pname = "arcticons-sans";

  src = fetchzip {
    hash = "sha256-BRyYHOuz7zxD1zD4L4DmI9dFhGePmGFDqYmS0DIbvi8=";
    url = "https://github.com/arcticons-team/arcticons-font/archive/refs/tags/${finalAttrs.version}.zip";
  };

  version = "0.580";
})
