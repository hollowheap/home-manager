{ lib, ... }:
{
  imports = let
    files = lib.filesystem.listFilesRecursive ./.;

    isValid = file: let
      filePath = toString file;
    in
      lib.hasSuffix ".nix" filePath
      && baseNameOf filePath != "default.nix";
  in 
    lib.filter isValid files;
}
