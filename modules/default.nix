{ lib, ... } : let
  files = lib.filesystem.listFilesRecursive ./.;
  nixFiles = builtins.filter (f: lib.hasSuffix ".nix" f && baseNameOf f != "default.nix") files;
in {
  imports = nixFiles;
}
