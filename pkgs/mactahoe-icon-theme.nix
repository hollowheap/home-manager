{ stdenvNoCC, fetchFromGitHub, gtk3, jdupes, ... }:
stdenvNoCC.mkDerivation (_: {
  pname = "mactahoe-icon-theme";
  version = "latest";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-icon-theme";
    rev = "main";
    hash = "sha256-NAahlBOYub0QlqkYStamoCbyWh+H5JG/iFm4Ws9EU3A=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    bash install.sh -d $out/share/icons

    find $out -type l ! -exec test -e {} \; -delete

    jdupes --quiet --link-hard --recurse $out/share

    runHook postInstall
  '';

})
