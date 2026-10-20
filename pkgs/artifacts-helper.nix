{
  writeShellApplication,
  symlinkJoin,
  coreutils,
  gnugrep,
  gawk,
  ...
}:
let
  artifactsApp = writeShellApplication {
    name = "artifacts.sh";
    runtimeInputs = [
      coreutils
      gnugrep
      gawk
    ];
    text = builtins.readFile ./artifacts-helper.sh;
  };
in
symlinkJoin {
  name = "artifacts-helper";
  paths = [ artifactsApp ];
  postBuild = ''
    ln -s $out/bin/artifacts.sh $out/bin/artifacts-helper
    ln -s $out/bin/artifacts.sh $out/bin/artifacts
  '';
}
