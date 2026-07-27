{ stdenvNoCC, fetchFromGitHub, gtk3, jdupes, ... }:
stdenvNoCC.mkDerivation (_: {
  pname = "mactahoe-icon-theme";
  version = "latest";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-icon-theme";
    rev = "main";
    hash = "sha256-J00zEUyItmIMpGn5cZQkP5v5GfiNqc2s4No3WK6GGWg=";
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
