{
  description = "hollowheap's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    noctalia-shell.url = "github:noctalia-dev/noctalia-shell";
    noctalia-shell.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, noctalia-shell, zen-browser, nvf, ...} @ inputs :
  {
    homeConfigurations."hollowheap@NIXPC-HOLLOWHEAP" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [
	noctalia-shell.homeModules.default
	zen-browser.homeModules.twilight-official
	nvf.homeManagerModules.default
        ./home.nix
      ];
    };
  };
}
