{
  description = "hollowheap's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell/cachix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
    extra-substituters = [ "http://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  outputs =
    inputs:
    let
      unfreePackages = [
        "modrinth-app"
        "modrinth-app-unwrapped"
        "antigravity-cli"
      ];

      packageConfig = {
        localSystem = "x86_64-linux";

        config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) unfreePackages;
        config.permittedInsecurePackages = [ "electron-40.10.5" ];

        overlays = [
          (final: prev: {
            stable = import inputs.nixpkgs-stable {
              localSystem = prev.stdenv.hostPlatform.system;
              config = {
                allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs-stable.lib.getName pkg) unfreePackages;
                permittedInsecurePackages = [ "electron-40.10.5" ];
              };
            };
          })
          (_: prev: import ./pkgs/default.nix prev)
        ];
      };

      stateVersionConfig = {
        home.stateVersion = "26.11";
      };

      homeConfig = username: {
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
        };
      };

      hmConfigurations =
        with inputs;
        usernames:
        nixpkgs.lib.genAttrs usernames (
          name:
          let
            pkgs = import nixpkgs packageConfig;
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            extraSpecialArgs = {
              inherit inputs;
              stable = pkgs.stable;
            };

            modules = [
              stylix.homeModules.stylix
              noctalia-shell.homeModules.default
              zen-browser.homeModules.twilight
              nvf.homeManagerModules.default
              stateVersionConfig
              (homeConfig name)
              ./home.nix
            ];
          }
        );
    in
    {
      homeConfigurations = hmConfigurations [ "hollowheap" ];
    };
}
