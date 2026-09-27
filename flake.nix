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
    extra-substituters = [ "https://noctalia.cachix.org" ];
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
        "kiro-cli"
        "kiro-cli-unwrapped"
        "steam"
        "steam-unwrapped"
        "zoom"
      ];

      packageConfig = {
        localSystem = "x86_64-linux";

        config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) unfreePackages;
        # config.permittedInsecurePackages = [ "electron-40.10.5" ];

        overlays = [ (_: prev: import ./pkgs/default.nix prev) ];
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

      pkgs = import inputs.nixpkgs packageConfig;

      hmConfigurations =
        with inputs;
        usernames:
        nixpkgs.lib.genAttrs usernames (
          name:
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

      devShells.x86_64-linux =
        let
          pico-sdk = pkgs.pico-sdk.override { withSubmodules = true; };
        in
        {
          pico = pkgs.mkShell {
            name = "pico-dev";
            packages = with pkgs; [
              cmake
              gnumake
              gcc-arm-embedded
              pico-sdk
              python3
            ];
            env = {
              PICO_SDK_PATH = "${pico-sdk}/lib/pico-sdk";
            };
            shellHook = ''
              rm -f .clangd
              cat << EOF > .clangd
CompileFlags:
  CompilationDatabase: build
  Add:
    - -isystem
    - ${pkgs.gcc-arm-embedded}/arm-none-eabi/include
EOF
            '';
          };

          python = pkgs.mkShell {
            name = "python-dev";
            packages = with pkgs; [
              python3
              uv
            ];
          };

          rust = pkgs.mkShell {
            name = "rust-dev";
            packages = with pkgs; [
              cargo
              rustc
              rustfmt
              clippy
              rust-analyzer
            ];
          };

          nix = pkgs.mkShell {
            name = "nix-dev";
            packages = with pkgs; [
              nil
              nixfmt
            ];
          };
        };
    };
}
