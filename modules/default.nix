{ lib, ... }: let
  inherit (builtins) readDir;
  inherit (lib) hasSuffix filter;
  inherit (lib.filesystem) listFilesRecursive;
in {
  imports = let
    files = listFilesRecursive ./.;

    isValid = file: let
      filePath = toString file;
    in
      hasSuffix ".nix" filePath
      && baseNameOf filePath != "default.nix";
  in 
    filter isValid files;
}
