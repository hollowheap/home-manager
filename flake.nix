{
  description = "hollowheap's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    hm.url = "github:nix-community/home-manager/release-26.05";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix/release-26.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    noctalia-shell.url = "github:noctalia-dev/noctalia-shell";
    noctalia-shell.inputs.nixpkgs.follows = "nixpkgs";

    # Apps
    zen-browser.url = "github:0xc000022070/zen-browser-flake/beta";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    # zen-browser.inputs.home-manager.follows = "home-manager";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, hm, ... }@inputs:
    {
      homeConfigurations."hollowheap@NIXPC-HOLLOWHEAP" =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfreePredicate =
                pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "discord"
                  "modrinth-app-unwrapped"
                  "modrinth-app"
                ];
            };
          };
        in
        hm.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
          } // { inherit pkgs; };
          modules = [
            inputs.stylix.homeModules.stylix
            inputs.noctalia-shell.homeModules.default
            inputs.zen-browser.homeModules.twilight
            inputs.nvf.homeManagerModules.default
            ./home.nix
          ];
        };
    };
}
